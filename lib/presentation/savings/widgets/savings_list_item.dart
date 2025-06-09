import 'package:budgetmaster/domain/models/saving.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';

class SavingsListItem extends StatelessWidget {
  final Saving saving;
  final String safeName;
  final VoidCallback onTap;

  const SavingsListItem({
    super.key,
    required this.saving,
    required this.safeName,
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
                  saving.name,
                  style: AppTypography.title3.copyWith(
                    color: AppColors.neutral1,
                  ),
                ),
                Text(
                  _formatDate(saving.date),
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.neutral3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  safeName ?? "Brak skarbonki",
                  style: AppTypography.caption2.copyWith(
                    color: AppColors.neutral3,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Kwota: ",
                      style: AppTypography.caption2.copyWith(
                        color: AppColors.neutral3,
                      ),
                    ),
                    Text(
                      "${saving.amount.toStringAsFixed(2)}zł",
                      style: AppTypography.caption2.copyWith(
                        color: AppColors.primary1,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Możesz dodać własne formatowanie jeśli chcesz
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
