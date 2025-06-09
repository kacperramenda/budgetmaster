import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/models/expense_split.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:budgetmaster/presentation/split_expense/cubit/expense_split_cubit.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
            color: const Color(0xFF3629B7).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 220,
                              height: 220,
                              child: Center(
                                child: QrImageView(
                                  data: 'https://buy.stripe.com/test_6oUbJ14P7bc18byanfcQU00',
                                  version: QrVersions.auto,
                                  size: 200,
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Zamknij', style: AppTypography.body1.copyWith(color: AppColors.primary1,))
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      QrImageView(
                        data: 'https://buy.stripe.com/test_6oUbJ14P7bc18byanfcQU00',
                        size: 60,
                      ),
                    ],
                  ),
                ),
                ],
              ),
              const SizedBox(width: 8),
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
                    builder: (context) => Theme(
                      data: Theme.of(context).copyWith(
                        dialogTheme: DialogThemeData(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          
                        ),
                      ),
                      child: AlertDialog(
                        title: Text('Potwierdź usunięcie', style: AppTypography.title2,),
                        content: Text(
                          'Czy na pewno chcesz usunąć ten podział wydatku?',
                          style: AppTypography.body3.copyWith(color: AppColors.neutral1),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Anuluj', style: TextStyle(color: AppColors.primary1),),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Usuń', style: TextStyle(color: AppColors.semanticRed)),
                          ),
                        ],
                      ),
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
