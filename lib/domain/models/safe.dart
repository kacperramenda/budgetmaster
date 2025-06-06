/*

SAFE MODEL

This model represents an safe where user can add saving. 

---------------------------------------------------------------------------------------------------------------------------------------------------------------

Properties:

- id: Unique identifier for the safe.
- name: The name of the safe.
- goalAmount: The target amount for the safe.
- currentAmount: The current amount added to safe.
- color: Optional color associated with the safe.

---------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

class Safe {
  final String id;
  final String name;
  final double goalAmount;
  final double currentAmount;
  final String? color;

  Safe({
    required this.id,
    required this.name,
    required this.goalAmount,
    required this.currentAmount,
    this.color,
  });

  Safe copyWith({
    String? id,
    String? name,
    double? goalAmount,
    double? currentAmount,
    String? color,
  }) {
    return Safe(
      id: id ?? this.id,
      name: name ?? this.name,
      goalAmount: goalAmount ?? this.goalAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      color: color ?? this.color,
    );
  }
}
