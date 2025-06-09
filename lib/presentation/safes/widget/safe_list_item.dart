import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:flutter/material.dart';

class SafeListItem extends StatelessWidget {
  final Safe safe;

  const SafeListItem({
    super.key,
    required this.safe,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/safe-details',
          arguments: safe,
        );
      },
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
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: safe.color != null
                        ? Color(int.parse(safe.color!))
                        : AppColors.primary1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      safe.name,
                      style: AppTypography.body1.copyWith(
                        color: AppColors.neutral1,
                        fontWeight: FontWeight.w600,)
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Cel: ${safe.goalAmount.toStringAsFixed(2)}zł",
                          style: AppTypography.caption1.copyWith(
                            color: AppColors.primary1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "(${safe.currentAmount}zł)",
                          style: AppTypography.caption1.copyWith(color: AppColors.semanticGreen),
                        ),
                      ],
                    )
                  ],
                ),

                const Spacer(),

                Text(
                  "${((safe.currentAmount / safe.goalAmount) * 100).toStringAsFixed(0)}%",
                  style: AppTypography.title2.copyWith(
                    color: AppColors.neutral1,
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}