/*

HOME VIEW

*/

// Removed unused import
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/presentation/home/widgets/tiles.dart';
import 'package:flutter/material.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary1,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 24),
          child: Row(children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.neutral6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  "Cześć, Kacper!",
                  style: AppTypography.body1.copyWith(
                    color: AppColors.neutral6
                  )
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.neutral6,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    children: [
                      MenuTile(
                        svgPath: 'assets/icons/budget.svg',
                        label: 'Kategorie',
                        onTap: () {
                          Navigator.pushNamed(context, '/budget-categories');
                        },
                      ),
                      MenuTile(
                        svgPath: 'assets/icons/savings.svg',
                        label: 'Sejfy',
                        onTap: () {
                          Navigator.pushNamed(context, '/safes');
                        },
                      ),
                      MenuTile(
                        svgPath: 'assets/icons/expenses.svg',
                        label: 'Wydatki',
                        onTap: () {
                          Navigator.pushNamed(context, '/expenses');
                        },
                      ),
                      MenuTile(
                        svgPath: 'assets/icons/expenses-set.svg',
                        label: 'Zestawienie wydatków',
                        iconColor: AppColors.semanticBlue,
                        onTap: () {
                          Navigator.pushNamed(context, '/expenses-set');
                        },
                      ),
                      MenuTile(
                        svgPath: 'assets/icons/add-icon.svg',
                        label: 'Dodaj wydatek',
                        iconColor: AppColors.semanticRed,
                        onTap: () {
                          Navigator.pushNamed(context, '/add-expense');
                        },
                      ),
                      MenuTile(
                        svgPath: 'assets/icons/add-icon.svg',
                        label: 'Dodaj kategorię',
                        iconColor: AppColors.semanticOrange,
                        onTap: () {
                          Navigator.pushNamed(context, '/add-budget-category');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ])
    );
  }
}