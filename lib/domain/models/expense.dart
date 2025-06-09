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

*/

class Expense {
  final String id;
  final String name;
  final String categoryId;
  final DateTime date;
  final double amount;
  final String description;
  final bool isSplitted;
  final bool isPaid;
  final double paidAmount;
  final String? receiptImagePath;

  Expense({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.date,
    required this.amount,
    required this.description,
    this.isSplitted = false,
    this.isPaid = false,
    this.paidAmount = 0.0,
    this.receiptImagePath,
  });

  Expense copyWith({
    String? id,
    String? name,
    String? categoryId,
    DateTime? date,
    double? amount,
    String? description,
    bool? isSplitted,
    bool? isPaid,
    double? paidAmount,
    String? receiptImagePath,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      isSplitted: isSplitted ?? this.isSplitted,
      isPaid: isPaid ?? this.isPaid,
      paidAmount: paidAmount ?? this.paidAmount,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
    );
  }
}