import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:budgetmaster/presentation/split_expense/cubit/expense_split_cubit.dart';
import 'package:budgetmaster/presentation/split_expense/widget/expense_split_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseSplitView extends StatefulWidget {
  final Expense expense;

  const ExpenseSplitView({super.key, required this.expense});

  @override
  State<ExpenseSplitView> createState() => _ExpenseSplitViewState();
}

class _ExpenseSplitViewState extends State<ExpenseSplitView> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseSplitCubit>().getExpenseSplitsForExpense(widget.expense.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ExpenseSplitCubit, ExpenseSplitState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Podziel wydatek',
                showAddButton: true,
                onAddPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/expense-split-add',
                    arguments: widget.expense,
                  );
                  if (!mounted) return;
                  if (result == true) {
                    // Odśwież listę podziałów
                    context.read<ExpenseSplitCubit>().getExpenseSplitsForExpense(widget.expense.id);

                    // Odśwież stan wydatku (np. isSplitted = true)
                    context.read<ExpenseCubit>().reloadExpense(widget.expense.id);
                  }
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<ExpenseSplitCubit, ExpenseSplitState>(
                  builder: (context, state) {
                    if (state.splits.isEmpty) {
                      return const Center(child: Text("Brak podziału wydatku"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.splits.length,
                      itemBuilder: (context, index) {
                        final entry = state.splits[index];
                        return ExpenseSplitListItem(
                          split: entry,
                          expense: widget.expense,
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/edit-split-expense',
                              arguments: entry,
                            );
                            if (!context.mounted) return;
                            if (result == true) {
                              await context.read<ExpenseSplitCubit>().getExpenseSplitsForExpense(widget.expense.id);
                              await context.read<ExpenseCubit>().reloadExpense(widget.expense.id);
                              Navigator.pop(context, true);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
