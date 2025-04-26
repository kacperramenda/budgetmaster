/*

RESPONSIBLE FOR UI OF THE EXPENSES VIEW

- use BlocBuilder

*/

import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/presentation/expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: BlocBuilder<ExpenseCubit, List<Expense>>(
        builder: (context, expenses) {
          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses found'));
          }
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ListTile(
                title: Text(expense.name),
                subtitle: Text('${expense.amount} - ${expense.category}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<ExpenseCubit>().deleteExpense(expense.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
