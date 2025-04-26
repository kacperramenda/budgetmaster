/*

EXPENSE LIST PAGE

This page displays and provides list of expenses.

*/


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/presentation/expense_cubit.dart';
import 'package:budgetmaster/presentation/expenses_view.dart';

class ExpensesPage extends StatelessWidget {
  final ExpenseRepository expensesRepository;

  const ExpensesPage({Key? key, required this.expensesRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ExpenseCubit(expensesRepository),
    child: const ExpensesView(),
    );
  }
}