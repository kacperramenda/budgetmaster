/*

EXPENSE LIST PAGE

This page displays and provides list of expenses.

*/


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:budgetmaster/presentation/expenses/view/expenses_view.dart';
import 'package:budgetmaster/domain/repository/budget_category_repo.dart';

class ExpensesPage extends StatelessWidget {
  final ExpenseRepository expensesRepository;
  final BudgetCategoryRepository budgetCategoryRepository;

  const ExpensesPage({
    super.key,
    required this.expensesRepository,
    required this.budgetCategoryRepository,
  });
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseCubit(expensesRepository, budgetCategoryRepository),
      child: const ExpensesView(),
    );
  }
}