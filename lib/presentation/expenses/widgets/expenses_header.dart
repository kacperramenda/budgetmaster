import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/common/addButton.dart';

class ExpensesHeader extends StatelessWidget {
  const ExpensesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 24),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          const SizedBox(width: 8),
          const Text(
            'Wydatki',
            style: TextStyle(
              fontSize: 20, // Title2
              fontWeight: FontWeight.w600,
              color: AppColors.neutral1,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
          const Spacer(),
          RoundAddButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-expense');
            },
          ),
        ],
      ),
    );
  }
}
