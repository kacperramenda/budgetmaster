/*

SAFES LIST PAGE

This page displays and provides list of safes.

*/

import 'package:budgetmaster/domain/repository/safe_repo.dart';
import 'package:budgetmaster/domain/repository/saving_repo.dart';
import 'package:budgetmaster/presentation/safes/view/safes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';

class SafesPage extends StatelessWidget {
  const SafesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SafeCubit(RepositoryProvider.of<SafeRepository>(context), 
          RepositoryProvider.of<SavingRepository>(context))
        ..loadSafes(),
      child: const SafesView(),
    );
  }
}