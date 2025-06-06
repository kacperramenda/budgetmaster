/*

ISAR EXPENSE MODEL


Convert the Expense model to an Isar model. This model is used to store expenses in the Isar database.

*/

import 'package:isar/isar.dart';
import 'package:budgetmaster/domain/models/expense.dart';

 // Generated code for Isar model. 
part 'isar_expense.g.dart'; // dart run build_runner build

@collection
class IsarExpense {
  Id id = Isar.autoIncrement; // Unique identifier for the expense.
  late String name; // The name of the expense.
  late String budgetCategoryId; // The category of the expense.
  late DateTime date; // The date of the expense.
  late double amount; // The amount of the expense.
  late String description; // A description of the expense.
  late bool isSplitted; // A boolean indicating if the expense is split among multiple users.
  late bool isPaid; // A boolean indicating if the expense has been paid.

  Expense toDomain() {
      return Expense(
        id: id.toString(),
        name: name,
        categoryId: budgetCategoryId,
        date: date,
        amount: amount,
        description: description,
        isSplitted: isSplitted,
        isPaid: isPaid,
      );
    }

  static IsarExpense fromDomain(Expense expense) {
    return IsarExpense()
      ..id = int.parse(expense.id)
      ..name = expense.name
      ..budgetCategoryId = expense.categoryId
      ..date = expense.date
      ..amount = expense.amount
      ..description = expense.description
      ..isSplitted = expense.isSplitted
      ..isPaid = expense.isPaid;
  }
}

