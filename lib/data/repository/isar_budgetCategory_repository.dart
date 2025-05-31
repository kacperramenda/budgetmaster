/*

DATABASE REPOSITORY

*/

import 'package:budgetmaster/data/models/isar_budgetCategory.dart';
import 'package:budgetmaster/domain/models/budgetCategory.dart';
import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';
import 'package:isar/isar.dart';

class IsarCategoryRepository implements BudgetCategoryRepository {
  //database instance
  final Isar db;

  IsarCategoryRepository(this.db);

  //get categories
  @override
  Future<List<BudgetCategory>> getAllCategories() async {
    // Fetch all categories from the Isar database asynchronously.
    final categories = await db.collection<IsarBudgetCategory>().where().findAll();

    // Convert IsarBudgetCategory to BudgetCategory using the toDomain method
    // and return the list of categories.
    return categories.map((isarCategory) => isarCategory.toDomain()).toList();
  }

  //get category by id
  @override
  Future<BudgetCategory?> getCategoryById(String id) async {
    // Fetch a category by its ID from the Isar database asynchronously.
    final category = await db.collection<IsarBudgetCategory>().get(int.parse(id));

    // Convert IsarBudgetCategory to BudgetCategory using the toDomain method
    // and return the category.
    return category?.toDomain();
  }

  //get category by id for current month and year
  @override
  Future<BudgetCategory?> getCategoryByIdForSelectedMonth(String id, String month, String year) async {
    // Fetch a category by its ID for the current month and year from the Isar database asynchronously.
    final category = await db
        .collection<IsarBudgetCategory>()
        .filter()
        .idEqualTo(int.parse(id))
        .monthEqualTo(month)
        .yearEqualTo(year)
        .findFirst();

    // Convert IsarBudgetCategory to BudgetCategory using the toDomain method
    // and return the category.
    return category?.toDomain();
  }

  //get categories for current month
  @override
Future<List<BudgetCategory>> getCategoriesForSelectedMonth(String month, String year) async {
  final categories = await db
      .collection<IsarBudgetCategory>()
      .filter()
      .monthEqualTo(month)
      .yearEqualTo(year)
      .findAll();

  return categories.map((isarCategory) => isarCategory.toDomain()).toList();
}


  //add category
  @override
  Future<void> addCategory(BudgetCategory category) async {
    // Convert BudgetCategory to IsarBudgetCategory using the fromDomain method
    // and add it to the Isar database asynchronously.
    await db.writeTxn(() async {
      await db.collection<IsarBudgetCategory>().put(IsarBudgetCategory.fromDomain(category));
    });
  }

  //update category
  @override
  Future<void> updateCategory(BudgetCategory category) async {
    // Convert BudgetCategory to IsarBudgetCategory using the fromDomain method
    // and update it in the Isar database asynchronously.
    await db.writeTxn(() async {
      await db.collection<IsarBudgetCategory>().put(IsarBudgetCategory.fromDomain(category));
    });
  }

  //delete category
  @override
  Future<void> deleteCategory(String id) async {
    // Delete a category by its ID from the Isar database asynchronously.
    await db.writeTxn(() async {
      await db.collection<IsarBudgetCategory>().delete(int.parse(id));
    });
  }
}