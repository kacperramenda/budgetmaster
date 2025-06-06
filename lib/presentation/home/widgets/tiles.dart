import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuTile extends StatelessWidget {
  final String svgPath; // ścieżka do ikony
  final VoidCallback onTap; // co zrobić po kliknięciu
  final String label; // opcjonalny tekst pod ikoną
  final Color? iconColor; // opcjonalny kolor ikony

  const MenuTile({
    super.key,
    required this.svgPath,
    this.iconColor,
    required this.onTap,
    required this.label,
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
            SvgPicture.asset(
              svgPath,
              width: 28,
              height: 28,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                label,
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
