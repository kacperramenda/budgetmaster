/*

DATABASE REPOSITORY

*/

import 'package:budgetmaster/data/models/isar_expense.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:isar/isar.dart';

class IsarTodoRepo implements ExpenseRepository {
  //database instance
  final Isar db;

  IsarTodoRepo(this.db);

  //get expenses
  @override
  Future<List<Expense>> getAllExpenses() async {
    // Fetch all expenses from the Isar database asynchronously.
    final expenses = await db.isarExpenses.where().findAll();

    // Convert IsarExpense to Expense using the toDomain method
    // and return the list of expenses.
    return expenses.map((isarExpense) => isarExpense.toDomain()).toList();
  }

  //add expense
  @override
  Future<void> addExpense(Expense expense) {
    final isarExpense = IsarExpense.fromDomain(expense);

    return db.writeTxn(() => db.isarExpenses.put(isarExpense));
  }

  //delete expense
  @override
  Future<void> deleteExpense(String id) async {
    await db.writeTxn(() => db.isarExpenses.delete(int.parse(id)));
  }    

  //update expense
  @override
  Future<void> updateExpense(Expense expense) {
    final isarExpense = IsarExpense.fromDomain(expense);

    return db.writeTxn(() => db.isarExpenses.put(isarExpense));
  }

  @override
  Future<Expense?> getExpenseById(String id) {
    return db.isarExpenses.get(int.parse(id)).then((isarExpense) {
      if (isarExpense != null) {
        return isarExpense.toDomain();
      }
      return null;
    });
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String category) {
    return db.isarExpenses
        .filter()
        .categoryEqualTo(category)
        .findAll()
        .then((isarExpenses) {
      return isarExpenses.map((isarExpense) => isarExpense.toDomain()).toList();
    });
  }
}