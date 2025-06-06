import 'package:flutter/material.dart';
import 'package:budgetmaster/domain/models/budget_category.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/budget_categories/cubit/budget_category_cubit.dart';

class BudgetCategoryDetailsView extends StatelessWidget {
  final BudgetCategory category;

  const BudgetCategoryDetailsView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: 
          BlocListener<BudgetCategoryCubit, BudgetCategoryState>(listener: (context, state) {
          if (state is BudgetCategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is BudgetCategoryInitial) {
            Navigator.pop(context, true); // Sukces — wracamy
          }
        }, 
        child: Column(
        children: [
          const PageHeader(
            route: '/budget-categories',
            title: 'Szczegóły kategorii',
            showAddButton: false,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("Nazwa", category.name),
                  _buildRow("Budżet początkowy", "${category.startAmount.toStringAsFixed(2)} zł"),
                  _buildRow("Budżet aktualny", "${category.currentAmount.toStringAsFixed(2)} zł"),
                  _buildRow("Miesiąc", category.month),
                  _buildRow("Rok", category.year),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.neutral5,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kolor",
                          style: AppTypography.body1.copyWith(
                            color: AppColors.neutral2,
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: category.color != null
                                ? Color(int.parse(category.color!))
                                : AppColors.primary1,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.neutral4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Builder(
                    builder: (context) => InkWell(
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Potwierdzenie"),
                            content: const Text("Czy na pewno chcesz usunąć tę kategorię?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Anuluj"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Usuń"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await context.read<BudgetCategoryCubit>().deleteCategory(category.id);
                            if (!context.mounted) return;

                            Navigator.pop(context, true); // wróć do listy
                          } catch (e) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nie można usunąć kategorii z dodanymi wydatkami'),
                                backgroundColor: AppColors.semanticRed,
                              ),
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 48),
                        child: Center(
                          child: Text(
                            "Usuń kategorię",
                            style: AppTypography.body1.copyWith(
                              color: AppColors.semanticRed,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.neutral5,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body1.copyWith(
              color: AppColors.neutral2,
            ),
          ),
          Text(
            value,
            style: AppTypography.title3.copyWith(
              color: AppColors.primary1,
            ),
          ),
        ],
      ),
    );
  }
}
