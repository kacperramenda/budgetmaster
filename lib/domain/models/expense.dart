/*

EXPENSE MODEL

This model represents an expense in the application. 

---------------------------------------------------------------------------------------------------------------------------------------------------------------

Properties:

- id: Unique identifier for the expense.
- name: The name of the expense.
- category: The category of the expense.
- date: The date of the expense.
- amount: The amount of the expense.
- description: A description of the expense.
- isSplitted: A boolean indicating if the expense is split among multiple users.
- isPaid: A boolean indicating if the expense has been paid.

---------------------------------------------------------------------------------------------------------------------------------------------------------------

Methods:

- for now none

*/

class Expense {
  final String id;
  final String name;
  final String category;
  final DateTime date;
  final double amount;
  final String description;
  final bool isSplitted;
  final bool isPaid;

  Expense({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.amount,
    required this.description,
    this.isSplitted = false,
    this.isPaid = false,
  });
}