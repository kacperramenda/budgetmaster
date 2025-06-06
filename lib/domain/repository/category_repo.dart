/*

CATEGORY REPOSITORY


*/

import 'package:budgetmaster/domain/models/category.dart';

abstract class CategoryRepository {
  // Add category
  Future<void> addCategory(Category expense);
  
  // Update category
  Future<void> updateCategory(Category expense);
  
  // Delete category
  Future<void> deleteCategory(String id);
  
  // Get category by ID
  Future<Category?> getCategoryById(String id);
  
  // Get all categories
  Future<List<Category>> getAllCategories();
  
  // Get categories by month and year
  Future<List<Category?>> getCategoriesForSelectedMonth(String month, String year);
}
