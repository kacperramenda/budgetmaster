import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class MonthTile extends StatelessWidget {
  final VoidCallback onTap;
  final String monthName;
  final int monthNumber;

  const MonthTile({
    super.key,
    required this.onTap,
    required this.monthName,
    required this.monthNumber,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // żeby było klikalne z animacją
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Color(0xFF3629B7).withOpacity(0.07),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Text(
                monthName,
                style: AppTypography.caption2.copyWith(
                  color: AppColors.neutral2
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
