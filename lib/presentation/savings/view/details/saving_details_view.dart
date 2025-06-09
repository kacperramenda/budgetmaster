import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/domain/models/saving.dart';
import 'package:budgetmaster/presentation/savings/cubit/savings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/presentation/common/page_header.dart'; // <== Twój header
import 'package:flutter_bloc/flutter_bloc.dart';

String _formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}

class SavingDetailsView extends StatelessWidget {
  final Saving saving;

  const SavingDetailsView({super.key, required this.saving});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavingsCubit, SavingsState>(
      builder: (context, state) {
        // Znajdź kategorię pasującą do budgetCategoryId
        final safe = state.safes.firstWhere(
          (c) => c.id == saving.safeId,
          orElse: () => Safe(
            id: '',
            name: 'Nieznana',
            goalAmount: 0,
            currentAmount: 0,
            isFullfiled: false,            
          ),
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const PageHeader(
                title: 'Szczegóły oszczędności',
                showAddButton: false,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              "Nazwa",
                              style: AppTypography.body1.copyWith(
                                color: AppColors.neutral2,
                              ),
                            ),
                            Text(
                              saving.name,
                              style: AppTypography.title3.copyWith(
                                color: AppColors.primary1,
                              ),
                            ),
                          ],
                        ),
                      ),

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
                              "Skarbonka",
                              style: AppTypography.body1.copyWith(
                                color: AppColors.neutral2,
                              ),
                            ),
                            Text(
                              safe.name,
                              style: AppTypography.title3.copyWith(
                                color: AppColors.primary1,
                              ),
                            ),
                          ],
                        ),
                      ),

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
                              "Data",
                              style: AppTypography.body1.copyWith(
                                color: AppColors.neutral2,
                              ),
                            ),
                            Text(
                              _formatDate(saving.date),
                              style: AppTypography.title3.copyWith(
                                color: AppColors.primary1,
                              ),
                            ),
                          ],
                        ),
                      ),

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
                              "Kwota",
                              style: AppTypography.body1.copyWith(
                                color: AppColors.neutral2,
                              ),
                            ),
                            Text(
                              "${saving.amount.toStringAsFixed(2)} zł",
                              style: AppTypography.title3.copyWith(
                                color: AppColors.primary1,
                              ),
                            ),
                          ],
                        ),
                      ),

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
                              "Opis",
                              style: AppTypography.body1.copyWith(
                                color: AppColors.neutral2,
                              ),
                            ),
                            Text(
                              saving.description,
                              style: AppTypography.title3.copyWith(
                                color: AppColors.neutral3,
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
                                backgroundColor: AppColors.neutral6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Text("Potwierdzenie", style: AppTypography.title2),
                                content: const Text("Czy na pewno chcesz usunąć tą oszczędność?", style: AppTypography.body3),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text("Anuluj", style: AppTypography.body1.copyWith(
                                      color: AppColors.primary1,
                                    )
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text("Usuń", style: AppTypography.body1.copyWith(
                                      color: AppColors.semanticRed,
                                    )
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              if (!context.mounted) return;
                              await context.read<SavingsCubit>().deleteSaving(saving.id, context);
                              if (!context.mounted) return;
                              Navigator.pop(context, true); // wróć z informacją, że usunięto
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 48),
                            child: Center(
                              child: Text(
                                "Usuń oszczędność",
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
        );
      },
    );
  }
}
