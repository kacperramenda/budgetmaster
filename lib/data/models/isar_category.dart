/*

ISAR CATEGORY MODEL


Convert the Category model to an Isar model. This model is used to store categories in the Isar database.

*/

import 'package:isar/isar.dart';
import 'package:budgetmaster/domain/models/category.dart';

 // Generated code for Isar model. 
part 'isar_category.g.dart'; // dart run build_runner build

@collection
class IsarCategory {
  Id id = Isar.autoIncrement; // Unique identifier for the category.
  late String name; // The name of the category.
  late double startAmount; // The starting amount of the category.
  late double currentAmount; // The current amount of the category.
  late String month; // The month of the category.
  late String year; // The year of the category.

  Category toDomain() {
      return Category(
        id: id.toString(),
        name: name,
        startAmount: startAmount,
        currentAmount: currentAmount,
        month: month,
        year: year,
      );
    }

  static IsarCategory fromDomain(Category category) {
    return IsarCategory()
      ..id = int.parse(category.id)
      ..name = category.name
      ..startAmount = category.startAmount
      ..currentAmount = category.currentAmount
      ..month = category.month
      ..year = category.year;
  }
}

