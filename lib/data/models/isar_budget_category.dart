/*

ISAR CATEGORY MODEL


Convert the Category model to an Isar model. This model is used to store categories in the Isar database.

*/

import 'dart:ui';

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
  late String? color; // The color of the category, stored as a string (optional).

  BudgetCategory toDomain() {
      return BudgetCategory(
        id: id.toString(),
        name: name,
        startAmount: startAmount,
        currentAmount: currentAmount,
        month: month,
        year: year,
        color: color ?? '0xFF281C9D', // Default color if not set
      );
    }

  static IsarBudgetCategory fromDomain(BudgetCategory category) {
    return IsarBudgetCategory()
      ..id = int.parse(category.id)
      ..name = category.name
      ..startAmount = category.startAmount
      ..currentAmount = category.currentAmount
      ..month = category.month
      ..year = category.year
      ..color = category.color;
  }
}

