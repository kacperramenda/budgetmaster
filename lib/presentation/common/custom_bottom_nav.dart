import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color(0xFF3629B7).withOpacity(0.07),
          blurRadius: 30,
          offset: const Offset(0, -5),
        ),
      ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                asset: 'assets/icons/home.svg',
                label: 'Start',
                index: 0,
              ),
              _buildNavItem(
                asset: 'assets/icons/budget.svg',
                label: 'Kategorie',
                index: 1,
              ),
              _buildNavItem(
                asset: 'assets/icons/savings.svg',
                label: 'Skarbonki',
                index: 2,
              ),
              _buildNavItem(
                asset: 'assets/icons/expenses.svg',
                label: 'Wydatki',
                index: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required String asset, required String label, required int index}) {
    final bool isSelected = currentIndex == index;

    if (isSelected && label.isNotEmpty) {
      return GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary1,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                asset,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.neutral6,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.neutral6,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onTabSelected(index),
        child: SvgPicture.asset(
          asset,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
                  AppColors.neutral3,
                  BlendMode.srcIn,
                ),
        ),
      );
    }
  }
}
