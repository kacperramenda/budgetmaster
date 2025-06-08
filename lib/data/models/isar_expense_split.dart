/*

ISAR EXPENSE SPLIT MODEL

Convert the ExpenseSplit model to an Isar model. This model is used to store expense splits in the Isar database.

*/

import 'package:isar/isar.dart';
import 'package:budgetmaster/domain/models/expense_split.dart';

part 'isar_expense_split.g.dart'; // dart run build_runner build

@collection
class IsarExpenseSplit {
  Id id = Isar.autoIncrement; // Unique identifier for the expense split.
  late String expenseId; // The ID of the expense this split belongs to.
  late String name; // The name of the person responsible for this split.
  late double amount; // The amount to be paid by this person.
  late bool isPaid; // Whether this split has been paid.
  String? paymentLink; // Link to the Stripe payment page for this split (optional).

  ExpenseSplit toDomain() {
    return ExpenseSplit(
      id: id.toString(),
      expenseId: expenseId,
      name: name,
      amount: amount,
      isPaid: isPaid,
      paymentLink: paymentLink,
    );
  }

  static IsarExpenseSplit fromDomain(ExpenseSplit split) {
    return IsarExpenseSplit()
      ..id = int.parse(split.id)
      ..expenseId = split.expenseId
      ..name = split.name
      ..amount = split.amount
      ..isPaid = split.isPaid
      ..paymentLink = split.paymentLink;
  }
}