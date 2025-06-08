/*

EXPENSE SPLIT DATABASE REPOSITORY

*/

import 'package:budgetmaster/data/models/isar_category.dart';
import 'package:budgetmaster/data/models/isar_expense.dart';
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

  // Get all expense splits
  @override
  Future<List<ExpenseSplit>> getAllExpenseSplits() async {
    final splits = await db.isarExpenseSplits.where().findAll();
    return splits.map((isarSplit) => isarSplit.toDomain()).toList();
  }

  @override
  Future<void> updateExpenseState(String expenseId) async {
    final splits = await db.isarExpenseSplits
        .filter()
        .expenseIdEqualTo(expenseId)
        .findAll();

    final isarExpense = await db.isarExpenses.get(int.parse(expenseId));
    if (isarExpense == null) return;

    final isSplitted = splits.isNotEmpty;
    isarExpense.isSplitted = isSplitted;

    final double previousPaidAmount = isarExpense.paidAmount ?? 0.0;
    final double newPaidAmount = splits
        .where((split) => split.isPaid)
        .fold(0.0, (sum, split) => sum + split.amount);

    final bool allPaid = splits.isNotEmpty && splits.every((split) => split.isPaid);
    isarExpense.isPaid = allPaid;

    final budgetCategory = await db.isarCategorys
        .get(int.parse(isarExpense.budgetCategoryId));

    if (budgetCategory != null) {
      final double delta = newPaidAmount - previousPaidAmount;
      budgetCategory.currentAmount += delta;
      isarExpense.paidAmount = newPaidAmount;

      await db.writeTxn(() async {
        await db.isarExpenses.put(isarExpense);
        await db.isarCategorys.put(budgetCategory);
      });
    } else {
      // Brak przypisanej kategorii - tylko aktualizacja wydatku
      isarExpense.paidAmount = newPaidAmount;
      await db.writeTxn(() async {
        await db.isarExpenses.put(isarExpense);
      });
    }
  }
}

