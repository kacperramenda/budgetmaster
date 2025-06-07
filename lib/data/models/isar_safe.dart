/*

ISAR SAFE MODEL
Convert the Safe model to an Isar model. This model is used to store safes in the Isar database.

*/

import 'package:isar/isar.dart';
import 'package:budgetmaster/domain/models/safe.dart';
// Generated code for Isar model.
part 'isar_safe.g.dart'; // dart run build_runner build

@collection
class IsarSafe {
  Id id = Isar.autoIncrement; // Unique identifier for the safe.
  late String name; // The name of the safe.
  late double goalAmount; // The amount of money in the safe.
  late double currentAmount; // The current amount added to safe.
  late String? color; // Optional color associated with the safe.
  late bool isFulfilled; // This can be derived from goalAmount and currentAmount.

  Safe toDomain() {
    return Safe(
      id: id.toString(),
      name: name,
      goalAmount: goalAmount,
      currentAmount: currentAmount,
      color: color,
      isFullfiled: currentAmount >= goalAmount,
    );
  }

  static IsarSafe fromDomain(Safe safe) {
    return IsarSafe()
      ..id = int.parse(safe.id)
      ..name = safe.name
      ..goalAmount = safe.goalAmount
      ..currentAmount = safe.currentAmount
      ..color = safe.color
      ..isFulfilled = safe.isFullfiled;
  }
}