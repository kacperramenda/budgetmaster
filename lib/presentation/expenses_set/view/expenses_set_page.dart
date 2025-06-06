import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';
import 'package:budgetmaster/presentation/expensesSet/cubit/expensesSetCubit.dart';
import 'package:budgetmaster/presentation/expensesSet/view/expenses_set_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';

class ExpensesSetPage extends StatelessWidget {
  final ExpenseRepository repository;
  final BudgetCategoryRepository budgetCategoryRepository;

  const ExpensesSetPage({super.key, required this.repository, required this.budgetCategoryRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpensesSetCubit(repository, budgetCategoryRepository),
      child: const ExpensesSetView(),
    );
  }
}
