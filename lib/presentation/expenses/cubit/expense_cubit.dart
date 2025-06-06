/*

EXPENSE CUBIT

Each cubit is a list of expenses.

*/

import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/domain/repository/category_repo.dart';

class ExpenseState {
  final List<Expense> expenses;
  final List<Category> budgetCategories;
  final String selectedCategory;

  ExpenseState({
    required this.expenses,
    required this.budgetCategories,
    this.selectedCategory = '0',
  });
}

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository expenseRepo;
  final CategoryRepository categoryRepo;

  ExpenseCubit(this.expenseRepo, this.categoryRepo)
      : super(ExpenseState(expenses: [], budgetCategories: [], selectedCategory: '0')) {
    loadExpenses();
    _loadCategories();

  }

  Future<void> loadExpenses() async {
    final expenses = await expenseRepo.getAllExpenses();
    emit(ExpenseState(expenses: expenses, budgetCategories: state.budgetCategories));
  }

  Future<void> _loadCategories() async {
    final budgetCategories = await categoryRepo.getAllCategories();
    Category allCategory = Category(
      id: '0',
      name: 'Wszystkie',
      startAmount: 0,
      currentAmount: 0,
      month: DateTime.now().month.toString(),
      year: DateTime.now().year.toString(),
    );

    budgetCategories.insert(0, allCategory);
    emit(ExpenseState(expenses: state.expenses, budgetCategories: budgetCategories));
  }

  // Add expense
  Future<void> addExpense(
    String name,
    double amount,
    String budgetCategoryId,
    String description, {
    DateTime? date,
  }) async {
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      date: date ?? DateTime.now(),
      budgetCategoryId: budgetCategoryId,
      description: description,
      isSplitted: false,
      isPaid: false,
    );

    await expenseRepo.addExpense(newExpense);
    await _updateBudgetCategoryAmount(budgetCategoryId, amountDelta: -amount);
    loadExpenses();
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    final expense = state.expenses.firstWhere((e) => e.id == id);
    if (expense != null) {
      await expenseRepo.deleteExpense(id);
      await _updateBudgetCategoryAmount(expense.budgetCategoryId, amountDelta: expense.amount);
      loadExpenses();
    }
    // Update the budget category's current amount

  }

  // Update selected category and load expenses for that category
  Future<void> selectCategory(String budgetCategoryId) async {
    final selectedCategory = state.budgetCategories.firstWhere(
      (category) => category.id == budgetCategoryId,
      orElse: () => Category(
        id: '0',
        name: 'Wszystkie',
        startAmount: 0,
        currentAmount: 0,
        month: DateTime.now().month.toString(),
        year: DateTime.now().year.toString(),
      ),
    );

    if (selectedCategory.id == '0') {
      loadExpenses();
      return;
    }
    final expenses = await expenseRepo.getExpensesByBudgetCategoryId(selectedCategory.id);
    emit(ExpenseState(
      expenses: expenses,
      budgetCategories: state.budgetCategories,
      selectedCategory: selectedCategory.id,
    ));
  }

  Future<void> _updateBudgetCategoryAmount(String budgetCategoryId, {required double amountDelta}) async {
    if (budgetCategoryId == '0') return; // Don't update for "Wszystkie"
    final category = await categoryRepo.getCategoryById(budgetCategoryId);
    if (category != null) {
      final updatedCategory = category.copyWith(
        currentAmount: (category.currentAmount ?? 0) + amountDelta,
      );
      await categoryRepo.updateCategory(updatedCategory);
      await _loadCategories();
    }
  }
}