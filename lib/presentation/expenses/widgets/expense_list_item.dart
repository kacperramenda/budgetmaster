import 'package:flutter/material.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: title and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.name,
                  style: AppTypography.title3.copyWith(
                    color: AppColors.neutral1,
                  ),
                ),
                Text(
                  _formatDate(expense.date),
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.neutral3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Second row: Split / Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _labelValue("Podzielony", expense.isSplitted ? "Tak" : "Nie", AppColors.primary1),
                _labelValue("Kwota", "${expense.amount.toStringAsFixed(2)}zł", AppColors.primary1),
              ],
            ),

            const SizedBox(height: 8),

            // Third row: Paid
            if(expense.isSplitted)
              _labelValue("Opłacony", expense.isPaid ? "Tak" : "Nie", expense.isPaid ? AppColors.semanticGreen : AppColors.semanticRed),
          ],
        ),
      ),
    );
  }

  Widget _labelValue(String label, String value, Color valueColor) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: AppTypography.caption2.copyWith(
            color: AppColors.neutral3,
          ),
        ),
        Text(
          value,
          style: AppTypography.caption2.copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    // Możesz dodać własne formatowanie jeśli chcesz
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
