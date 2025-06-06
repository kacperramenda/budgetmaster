import 'package:budgetmaster/domain/repository/budget_category_repo.dart';
import 'package:budgetmaster/presentation/expenses_set/cubit/expenses_set_cubit.dart';
import 'package:budgetmaster/presentation/expenses_set/view/expenses_set_view.dart';
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
