/*

EXPENSE SPLIT DATABASE REPOSITORY

*/

import 'package:budgetmaster/data/models/isar_expense_split.dart';
import 'package:budgetmaster/domain/models/expense_split.dart';
import 'package:budgetmaster/domain/repository/expense_split_repo.dart';
import 'package:isar/isar.dart';

class IsarExpenseSplitRepository implements ExpenseSplitRepository {
  // Database instance
  final Isar db;

  IsarExpenseSplitRepository(this.db);

  // Add expense split
  @override
  Future<void> addExpenseSplit(ExpenseSplit split) {
    final isarSplit = IsarExpenseSplit.fromDomain(split);
    return db.writeTxn(() => db.isarExpenseSplits.put(isarSplit));
  }

  // Update expense split
  @override
  Future<void> updateExpenseSplit(ExpenseSplit split) {
    final isarSplit = IsarExpenseSplit.fromDomain(split);
    return db.writeTxn(() => db.isarExpenseSplits.put(isarSplit));
  }

  // Delete expense split
  @override
  Future<void> deleteExpenseSplit(String id) async {
    await db.writeTxn(() => db.isarExpenseSplits.delete(int.parse(id)));
  }

  // Get expense split by ID
  @override
  Future<ExpenseSplit?> getExpenseSplitById(String id) async {
    final isarSplit = await db.isarExpenseSplits.get(int.parse(id));
    return isarSplit?.toDomain();
  }

  // Get all expense splits for an expense
  @override
  Future<List<ExpenseSplit>> getAllExpenseSplitsForExpense(String expenseId) async {
    final splits = await db.isarExpenseSplits.filter().expenseIdEqualTo(expenseId).findAll();
    return splits.map((isarSplit) => isarSplit.toDomain()).toList();
  }
}

