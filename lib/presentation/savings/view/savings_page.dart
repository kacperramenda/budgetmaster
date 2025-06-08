/*

SAVINGS LIST PAGE

This page displays and provides list of safes.

*/

import 'package:budgetmaster/domain/repository/safe_repo.dart';
import 'package:budgetmaster/domain/repository/saving_repo.dart';
import 'package:budgetmaster/presentation/savings/cubit/savings_cubit.dart';
import 'package:budgetmaster/presentation/savings/view/savings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavingsCubit(RepositoryProvider.of<SavingRepository>(context), 
          RepositoryProvider.of<SafeRepository>(context))
        ..loadSavings(),
      child: const SavingsView(),
    );
  }
}