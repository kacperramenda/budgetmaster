/*

EXPENSE SPLIT REPOSITORY

*/

import 'package:budgetmaster/domain/models/expense_split.dart';

abstract class ExpenseSplitRepository {
  // Add expense split
  Future<void> addExpenseSplit(ExpenseSplit split);

  // Update expense split
  Future<void> updateExpenseSplit(ExpenseSplit split);

  // Delete expense split
  Future<void> deleteExpenseSplit(String id);

  // Get expense split by ID
  Future<ExpenseSplit?> getExpenseSplitById(String id);

  // Get all expense splits for an expense
  Future<List<ExpenseSplit>> getAllExpenseSplitsForExpense(String expenseId);
}