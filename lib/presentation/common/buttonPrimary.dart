import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ButtonPrimary({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary1, // #3629B6
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.zero,
          elevation: 4,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: AppTypography.body1.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        )
      ),
    );
  }
}
