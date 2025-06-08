import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/categories/cubit/category_cubit.dart';

class SafeDetailsView extends StatelessWidget {
  final Safe safe;

  const SafeDetailsView({super.key, required this.safe});

  @override
  Widget build(BuildContext context) {
    final isfilled = safe.currentAmount >= safe.goalAmount;
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: 
          BlocListener<CategoryCubit, CategoryState>(listener: (context, state) {
          if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CategoryInitial) {
            Navigator.pop(context, true); // Sukces — wracamy
          }
        }, 
        child: Column(
        children: [
          const PageHeader(
            title: 'Szczegóły skarbonki',
            showAddButton: false,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("Nazwa", safe.name),
                  _buildRow("Cel", "${safe.goalAmount.toStringAsFixed(2)} zł"),
                  _buildRow("Uzbierano", "${safe.currentAmount.toStringAsFixed(2)} zł"),
                  _buildRow("Stan", "${safe.currentAmount >= safe.goalAmount ? "Osiągnięto cel" : "Wciąż oszczędzamy"}"),
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
                            color: safe.color != null
                                ? Color(int.parse(safe.color!))
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
                            title: Text(isfilled ? "Gratulacje!" : "Potwierdzenie"),
                            content: Text(isfilled ? 'Czy napewno chcesz rozbić skarbonkę i usunąć wszystkie dodane oszczędności?' : 'Czy na pewno chcesz usunąć tą skarbonkę i wszystkie przypisane oszczędności?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Anuluj"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(isfilled ? "Rozbij" : "Usuń"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await context.read<SafeCubit>().deleteSafe(safe.id);
                            if (!context.mounted) return;

                            Navigator.pop(context, true); // wróć do listy
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Błąd podczas usuwania skarbonki: $e")),
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 48),
                        child: Center(
                          child: Text(
                            isfilled ? "Rozbij skarbonkę" : "Usuń skarbonkę",
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
