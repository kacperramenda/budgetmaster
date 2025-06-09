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
    String? receiptImagePath,
  }) async {
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      date: date ?? DateTime.now(),
      categoryId: budgetCategoryId,
      description: description,
      isSplitted: false,
      isPaid: false,
      paidAmount: 0.0,
      receiptImagePath: receiptImagePath,
    );

    await expenseRepo.addExpense(newExpense);
    await updateAllBudgetCategoryAmounts();
    loadExpenses();
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    final expense = state.expenses.firstWhere((e) => e.id == id);
    if (expense != null) {
      await expenseRepo.deleteExpense(id);
      await updateAllBudgetCategoryAmounts();
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

  Future<void> updateAllBudgetCategoryAmounts() async {
    try {
      final categories = await categoryRepo.getAllCategories();
      final expenses = await expenseRepo.getAllExpenses();

      for (final category in categories) {
        final matchingExpenses = expenses.where((e) => e.categoryId == category.id);
        final totalSpent = matchingExpenses.fold<double>(
          0.0,
          (sum, e) => sum + e.amount,
        );

        final updatedCategory = category.copyWith(currentAmount: category.startAmount - totalSpent);
        await categoryRepo.updateCategory(updatedCategory);
      }

      await _loadCategories();
    } catch (e) {
      print('Error updating budget category amounts: $e');
    }
  }


  // reload expense by id
  Future<void> reloadExpense(String id) async {
    final expense = await expenseRepo.getExpenseById(id);
    if (expense != null) {
      final expenses = List<Expense>.from(state.expenses);
      final index = expenses.indexWhere((e) => e.id == id);
      if (index != -1) {
        expenses[index] = expense;
        emit(ExpenseState(expenses: expenses, budgetCategories: state.budgetCategories, selectedCategory: state.selectedCategory));
      }
    }
  }

  // Update expense
  Future<void> updateExpense(
    String id,
    String name,
    double amount,
    String budgetCategoryId,
    String description, {
    DateTime? date,
    String? receiptImagePath,
  }) async {
    final updatedExpense = Expense(
      id: id,
      name: name,
      amount: amount,
      date: date ?? DateTime.now(),
      categoryId: budgetCategoryId,
      description: description,
      isSplitted: false,
      isPaid: false,
      paidAmount: 0.0,
      receiptImagePath: receiptImagePath,
    );

    await expenseRepo.updateExpense(updatedExpense);
    await updateAllBudgetCategoryAmounts();
    loadExpenses();
  }

}