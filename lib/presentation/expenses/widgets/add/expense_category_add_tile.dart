import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryAddTile extends StatelessWidget {
  final VoidCallback? onTap;

  const ExpenseCategoryAddTile({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral1.withOpacity(0.07),
              blurRadius: 30,
              offset: Offset(0, 4),
            ),
          ],
        ),
        // Dodaj padding wewnętrzny
        padding: const EdgeInsets.all(12),
        // Ten Box się rozciągnie jeśli otoczony IntrinsicHeight
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.neutral5,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.neutral6,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
