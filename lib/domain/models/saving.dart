/*

SAVING MODEL

This model represents saving that a user can add to created safe.

---------------------------------------------------------------------------------------------------------------------------------------------------------------

Properties:

- id: Unique identifier for the saving.
- name: The name of the saving.
- amount: The amount of the saving.
- date: The date of the saving.
- description: A description of the saving.
- safeId: The ID of the safe to which the saving belongs.

---------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

class Saving {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final String description;
  final String safeId;
  Saving({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.description,
    required this.safeId,
  });

  Saving copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? date,
    String? description,
    String? safeId,
  }) {
    return Saving(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      safeId: safeId ?? this.safeId,
    );
  }
}
