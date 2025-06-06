import 'package:budgetmaster/domain/repository/budget_category_repo.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/budget_categories/cubit/budget_category_cubit.dart';
import 'package:budgetmaster/presentation/budget_categories/view/budget_categories_view.dart';

class BudgetcategoriesPage extends StatelessWidget {
  final BudgetCategoryRepository budgetCategoryRepository;

  const BudgetcategoriesPage({
    super.key,
    required this.budgetCategoryRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetCategoryCubit(budgetCategoryRepository, 
          context.read<ExpenseRepository>()),
      child: const BudgetCategoriesView(),
    );
  }
}