/*

EXPENSE REPOSITORY


*/

import 'package:budgetmaster/domain/models/expense.dart';

abstract class ExpenseRepository {
  // Add expense
  Future<void> addExpense(Expense expense);
  
  // Update expense
  Future<void> updateExpense(Expense expense);
  
  // Delete expense
  Future<void> deleteExpense(String id);
  
  // Get expense by ID
  Future<Expense?> getExpenseById(String id);
  
  // Get all expenses
  Future<List<Expense>> getAllExpenses();
  
  // Get expenses by category
  Future<List<Expense>> getExpensesByBudgetCategoryId(String budgetCategoryId);
}
