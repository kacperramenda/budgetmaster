/*

EXPENSE SPLIT MODEL

This model represents an splitted parts of expense. 

---------------------------------------------------------------------------------------------------------------------------------------------------------------

Properties:

- id: Unique identifier for the category.
- expenseId: The ID of the expense this split belongs to.
- name: The name of the person responsible for this split.
- amount: The amount to be paid by this person.
- isPaid: Whether this split has been paid.
- paymentLink: (optional) Link to the Stripe payment page for this split.

---------------------------------------------------------------------------------------------------------------------------------------------------------------
*/


class ExpenseSplit {
  final String id;
  final String expenseId;
  final String name;           
  final double amount;         
  final bool isPaid;           
  final String? paymentLink;   

  ExpenseSplit({
    required this.id,
    required this.expenseId,
    required this.name,
    required this.amount,
    this.isPaid = false,
    this.paymentLink,
  });

  ExpenseSplit copyWith({
    String? id,
    String? expenseId,
    String? name,
    double? amount,
    bool? isPaid,
    String? paymentLink,
  }) {
    return ExpenseSplit(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      paymentLink: paymentLink ?? this.paymentLink,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expenseId': expenseId,
      'name': name,
      'amount': amount,
      'isPaid': isPaid,
      'paymentLink': paymentLink,
    };
  }

  factory ExpenseSplit.fromJson(Map<String, dynamic> json) {
    return ExpenseSplit(
      id: json['id'],
      expenseId: json['expenseId'],
      name: json['name'],
      amount: json['amount'],
      isPaid: json['isPaid'],
      paymentLink: json['paymentLink'],
    );
  }
}
