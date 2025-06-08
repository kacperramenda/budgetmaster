/*

ISAR SAVING MODEL
Convert the Saving model to an Isar model. This model is used to store savings in the Isar database.

*/

import 'package:isar/isar.dart';
import 'package:budgetmaster/domain/models/saving.dart';

part 'isar_saving.g.dart'; // dart run build_runner build

@collection
class IsarSaving {
  Id id = Isar.autoIncrement; // Unique identifier for the saving.
  late String name; // The name of the saving.
  late double amount; // The target amount for the saving.
  late DateTime date; // The current amount saved.
  late String description; // Optional color associated with the saving.
  late String safeId; // Indicates if the saving goal has been met.

  Saving toDomain() {
    return Saving(
      id: id.toString(),
      name: name,
      amount: amount,
      date: date,
      description: description,
      safeId: safeId,
    );
  }

  static IsarSaving fromDomain(Saving saving) {
    return IsarSaving()
      ..id = int.parse(saving.id)
      ..name = saving.name
      ..amount = saving.amount
      ..date = saving.date
      ..description = saving.description
      ..safeId = saving.safeId;
  }
}