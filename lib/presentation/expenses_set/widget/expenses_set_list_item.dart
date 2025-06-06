import 'package:flutter/material.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';

class ExpensesSetListItem extends StatelessWidget {
  final Expense expense;
  final Function onTap;
  final String? categoryName;

  const ExpensesSetListItem({
    super.key,
    required this.expense,
    required this.onTap,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(15),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: title and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.name,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.neutral1,
                  ),
                ),
                Text(
                  "- ${expense.amount.toStringAsFixed(2)}zł",
                  style: AppTypography.caption2.copyWith(
                    color: AppColors.semanticRed,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _labelValue(
                  "Kategoria",
                  categoryName ?? "Brak kategorii",
                  AppColors.neutral2,
                ),
              ],
            ),
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

}
