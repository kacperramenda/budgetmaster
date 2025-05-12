/*

CATEGORY MODEL

This model represents an expenses categories aka "safe" in the application. 

---------------------------------------------------------------------------------------------------------------------------------------------------------------

Properties:

- id: Unique identifier for the category.
- name: The name of the category.
- startAmount: The starting amount of the category.
- currentAmount: The current amount of the category.
- month: The month of the category.
- year: The year of the category.

---------------------------------------------------------------------------------------------------------------------------------------------------------------

Methods:

- for now none

*/

class Category {
  final String id;
  final String name;
  final double startAmount;
  final double currentAmount;
  final String month;
  final String year;

  Category({
    required this.id,
    required this.name,
    required this.startAmount,
    required this.currentAmount,
    required this.month,
    required this.year,
  });
}