import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/common/addButton.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String route;
  final bool showAddButton;
  final VoidCallback? onAddPressed;

  const PageHeader({
    super.key,
    required this.title,
    required this.route,
    this.showAddButton = false,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32, left: 8, right: 24),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero, 
            constraints: const BoxConstraints(), 
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: () {
              Navigator.pushReplacementNamed(context, route);
            },
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20, // Title2
              fontWeight: FontWeight.w600,
              color: AppColors.neutral1,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
          const Spacer(),
          if (showAddButton)
            RoundAddButton(
              onPressed: onAddPressed ??
                  () {
                    Navigator.pushNamed(context, '/add-expense');
                  },
            ),
        ],
      ),
    );
  }
}
