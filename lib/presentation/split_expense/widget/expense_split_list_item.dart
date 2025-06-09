import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/models/expense_split.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:budgetmaster/presentation/split_expense/cubit/expense_split_cubit.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseSplitListItem extends StatelessWidget {
  final ExpenseSplit split;
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseSplitListItem({
    super.key,
    required this.split,
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3629B7).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  split.name,
                  style: AppTypography.title3.copyWith(
                    color: AppColors.neutral1,
                  ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                  children: [
                    Text(
                    "Kwota: ",
                    style: AppTypography.caption2.copyWith(
                      color: AppColors.neutral3,
                    ),
                    ),
                    Text(
                    "${split.amount.toStringAsFixed(2)}zł",
                    style: AppTypography.caption2.copyWith(
                      color: AppColors.primary1,
                    ),
                    ),
                  ],
                  ),
                ],
                ),
              ),
              ),
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: split.isPaid,
                  activeColor: AppColors.primary1,
                  onChanged: (value) async {
                    if (value != null) {
                      await context.read<ExpenseSplitCubit>().updateExpenseSplit(
                        split.copyWith(isPaid: value),
                      );
                      // Odśwież stan Expense
                      context.read<ExpenseCubit>().reloadExpense(expense.id);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Potwierdź usunięcie'),
                      content: const Text('Czy na pewno chcesz usunąć ten podział wydatku?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Anuluj'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Usuń', style: TextStyle(color: AppColors.semanticRed)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await context.read<ExpenseSplitCubit>().deleteExpenseSplit(split.id);
                    context.read<ExpenseCubit>().reloadExpense(expense.id);
                  }
                },
                child: Text(
                  "Usuń",
                  style: AppTypography.caption2.copyWith(
                    color: AppColors.semanticRed,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
