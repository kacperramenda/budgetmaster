import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/savings/cubit/savings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplitExpenseView extends StatefulWidget {
  const SplitExpenseView({super.key});

  @override
  State<SplitExpenseView> createState() => _SplitExpenseViewState();
}

class _SplitExpenseViewState extends State<SplitExpenseView> {
  String selectedSafeId = '0';

  @override
  void initState() {
    super.initState();
    context.read<SavingsCubit>().loadSavings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SavingsCubit, SavingsState>(
        builder: (context, savingsState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Podziel wydatek',
                showAddButton: true,
                onAddPressed: () async {
                  final result = await Navigator.pushNamed(context, '/add-split-expense');
                  if (!mounted) return;
                  if (result == true) {
                    
                  }
                },
              ),

              
            ],
          );
        },
      ),
    );
  }
}
