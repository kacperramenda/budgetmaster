import 'package:budgetmaster/presentation/common/edit_button.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/common/add_button.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String route;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

  const PageHeader({
    super.key,
    required this.title,
    this.route = '',
    this.showAddButton = false,
    this.onAddPressed,
    this.showEditButton = false,
    this.onEditPressed,
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
              if (route != '') {
                Navigator.pushNamed(context, route);
              } else {
                Navigator.pop(context);
              }
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

          if (showEditButton)
            RoundEditButton(
              onPressed: onEditPressed ?? () {
                Navigator.pushNamed(context, '/edit-expense');
              },
            ),
        ],
      ),
    );
  }
}
