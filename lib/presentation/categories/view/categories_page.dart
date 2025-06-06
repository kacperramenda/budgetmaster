import 'package:budgetmaster/domain/repository/category_repo.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/categories/cubit/category_cubit.dart';
import 'package:budgetmaster/presentation/categories/view/categories_view.dart';

class CategoriesPage extends StatelessWidget {
  final CategoryRepository budgetCategoryRepository;

  const CategoriesPage({
    super.key,
    required this.budgetCategoryRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit(budgetCategoryRepository, 
          context.read<ExpenseRepository>()),
      child: const CategoriesView(),
    );
  }
}