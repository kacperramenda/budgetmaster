/*

EXPENSE CUBIT

Each cubit is a list of expenses.

*/

import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';

class ExpenseCubit extends Cubit<List<Expense>> {
  final ExpenseRepository expenseRepo;

  ExpenseCubit(this.expenseRepo) : super([]) {
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    // fetch all expenses from the repository
    final expenses = await expenseRepo.getAllExpenses();

    // emit the loaded expenses to the state
    emit(expenses);
  }

  // Add expense
  Future<void> addExpense(String name, double amount, String category, String description) async {
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      date: DateTime.now(),
      category: category,
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
}