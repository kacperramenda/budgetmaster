import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/budget_category.dart';

class BudgetCategoryListItem extends StatelessWidget {
  final BudgetCategory budgetCategory;
  final bool showMonth;
  final String? month;

  const BudgetCategoryListItem({
    Key? key,
    required this.budgetCategory,
    this.showMonth = false,
    this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/budget-category-details',
          arguments: budgetCategory,
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
              color: const Color(0xFF3629B7).withOpacity(0.07),
              blurRadius: 12,
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
                    color: budgetCategory.color != null
                        ? Color(int.parse(budgetCategory.color!))
                        : AppColors.primary1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${budgetCategory.name}${showMonth ? ', ' : ''}${showMonth ? month : ''}",
                      style: AppTypography.body1.copyWith(
                        color: AppColors.neutral1,
                        fontWeight: FontWeight.w600,)
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Budżet: ${budgetCategory.startAmount.toStringAsFixed(2)}zł",
                          style: AppTypography.caption1.copyWith(
                            color: AppColors.primary1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "(${budgetCategory.currentAmount}zł)",
                          style: AppTypography.caption1.copyWith(
                            color: budgetCategory.currentAmount >= 0
                                ? AppColors.semanticGreen
                                : AppColors.semanticRed,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ]
        ),
      ),
    );
  }
}