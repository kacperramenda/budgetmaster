/*

CATEGORY MODEL

This model represents an expense category. 

---------------------------------------------------------------------------------------------------------------------------------------------------------------

Properties:

- id: Unique identifier for the category.
- name: The name of the category.
- startAmount: The starting amount of the category.
- currentAmount: The current amount of the category.
- month: The month of the category.
- year: The year of the category.
- color: Optional color associated with the category.

---------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

class Category {
  final String id;
  final String name;
  final double startAmount;
  final double currentAmount;
  final String month;
  final String year;
  final String? color;

  Category({
    required this.id,
    required this.name,
    required this.startAmount,
    required this.currentAmount,
    required this.month,
    required this.year,
    this.color,

  });

  Category copyWith({
    String? id,
    String? name,
    double? startAmount,
    double? currentAmount,
    String? month,
    String? year,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      startAmount: startAmount ?? this.startAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      month: month ?? this.month,
      year: year ?? this.year,
      color: color ?? this.color,
    );
  }
}
