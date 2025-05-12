/*

EXPENSE CUBIT

Each cubit is a list of expenses.

*/

import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/models/budgetCategory.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';

class ExpenseState {
  final List<Expense> expenses;
  final List<BudgetCategory> budgetCategories;
  final String selectedCategory;

  ExpenseState({
    required this.expenses,
    required this.budgetCategories,
    this.selectedCategory = '0',
  });
}

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository expenseRepo;
  final BudgetCategoryRepository categoryRepo;

  ExpenseCubit(this.expenseRepo, this.categoryRepo)
      : super(ExpenseState(expenses: [], budgetCategories: [], selectedCategory: '0')) {
    _loadExpenses();
    _loadCategories();

  }

  Future<void> _loadExpenses() async {
    final expenses = await expenseRepo.getAllExpenses();
    emit(ExpenseState(expenses: expenses, budgetCategories: state.budgetCategories));
  }

  Future<void> _loadCategories() async {
    final budgetCategories = await categoryRepo.getAllCategories();
    BudgetCategory allCategory = BudgetCategory(
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
      String name, double amount, String budgetCategoryId, String description) async {
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      date: DateTime.now(),
      budgetCategoryId: budgetCategoryId,
      description: description,
      isSplitted: false,
      isPaid: false,
    );

    await expenseRepo.addExpense(newExpense);

    _loadExpenses();
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    await expenseRepo.deleteExpense(id);

    _loadExpenses();
  }

  // Update selected category and load expenses for that category
  Future<void> selectCategory(String budgetCategoryId) async {
    final selectedCategory = state.budgetCategories.firstWhere(
      (category) => category.id == budgetCategoryId,
      orElse: () => BudgetCategory(
        id: '0',
        name: 'Wszystkie',
        startAmount: 0,
        currentAmount: 0,
        month: DateTime.now().month.toString(),
        year: DateTime.now().year.toString(),
      ),
    );

    if (selectedCategory.id == '0') {
      _loadExpenses();
      return;
    }
    final expenses = await expenseRepo.getExpensesByBudgetCategoryId(selectedCategory.id);
    emit(ExpenseState(
      expenses: expenses,
      budgetCategories: state.budgetCategories,
      selectedCategory: selectedCategory.id,
    ));
  }
}