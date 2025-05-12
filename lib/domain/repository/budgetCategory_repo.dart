/*

CATEGORY REPOSITORY


*/

import 'package:budgetmaster/domain/models/budgetCategory.dart';

abstract class BudgetCategoryRepository {
  // Add category
  Future<void> addCategory(BudgetCategory expense);
  
  // Update category
  Future<void> updateCategory(BudgetCategory expense);
  
  // Delete category
  Future<void> deleteCategory(String id);
  
  // Get category by ID
  Future<BudgetCategory?> getCategoryById(String id);
  
  // Get all categories
  Future<List<BudgetCategory>> getAllCategories();
  
  // Get categories by month and year
  Future<List<BudgetCategory?>> getCategoriesForCurrentMonth(String month, String year);

  // Get category by id for current month and year
  Future<BudgetCategory?> getCategoryByIdForCurrentMonth(String id, String month, String year);
}
