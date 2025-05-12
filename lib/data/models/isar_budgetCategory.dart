/*

ISAR CATEGORY MODEL


Convert the Category model to an Isar model. This model is used to store categories in the Isar database.

*/

import 'package:isar/isar.dart';
import 'package:budgetmaster/domain/models/budgetCategory.dart';

 // Generated code for Isar model. 
part 'isar_budgetCategory.g.dart'; // dart run build_runner build

@collection
class IsarBudgetCategory {
  Id id = Isar.autoIncrement; // Unique identifier for the category.
  late String name; // The name of the category.
  late double startAmount; // The starting amount of the category.
  late double currentAmount; // The current amount of the category.
  late String month; // The month of the category.
  late String year; // The year of the category.

  BudgetCategory toDomain() {
      return BudgetCategory(
        id: id.toString(),
        name: name,
        startAmount: startAmount,
        currentAmount: currentAmount,
        month: month,
        year: year,
      );
    }

  static IsarBudgetCategory fromDomain(BudgetCategory category) {
    return IsarBudgetCategory()
      ..id = int.parse(category.id)
      ..name = category.name
      ..startAmount = category.startAmount
      ..currentAmount = category.currentAmount
      ..month = category.month
      ..year = category.year;
  }
}

