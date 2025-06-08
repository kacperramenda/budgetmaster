import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/repository/expense_split_repo.dart';
import 'package:budgetmaster/presentation/split_expense/cubit/expense_split_cubit.dart';
import 'package:budgetmaster/presentation/split_expense/view/expense_split_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseSplitPage extends StatelessWidget {
  const ExpenseSplitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final expense = ModalRoute.of(context)?.settings.arguments as Expense;
    
    return BlocProvider(
      create: (_) => ExpenseSplitCubit(
        RepositoryProvider.of<ExpenseSplitRepository>(context),
      ),
      child: ExpenseSplitView(expense: expense),
    );
  }
}
