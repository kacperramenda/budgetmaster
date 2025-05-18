import 'package:flutter/material.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/presentation/common/page_header.dart'; // <== Twój header

class ExpenseDetailsView extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailsView({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PageHeader(
            route: '/expenses',
            title: 'Szczegóły wydatku',
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
                    child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nazwa",
                        style: AppTypography.body1.copyWith(
                          color: AppColors.neutral2,
                        ),
                      ),
                      Text(
                        expense.name,
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
                    child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kategoria",
                        style: AppTypography.body1.copyWith(
                          color: AppColors.neutral2,
                        ),
                      ),
                      Text(
                        "expense.category.name",
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
                    child:
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Data",
                              style: AppTypography.body1.copyWith(
                                color: AppColors.neutral2,
                              ),
                            ),
                            Text(
                              _formatDate(expense.date),
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
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kwota",
                          style: AppTypography.body1.copyWith(
                            color: AppColors.neutral2,
                          ),
                        ),
                        Text(
                          "${expense.amount.toStringAsFixed(2)} zł",
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
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Podzielony",
                            style: AppTypography.body1.copyWith(
                              color: AppColors.neutral2,
                            ),
                          ),
                          Text(
                            expense.isSplitted ? "Tak" : "Nie",
                            style: AppTypography.title3.copyWith(
                              color: AppColors.primary1,
                            ),
                          ),
                        ],
                      ),
                  ),

                  if(expense.isSplitted)
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
                          "Opłacony",
                          style: AppTypography.body1.copyWith(
                          color: AppColors.neutral2,
                          ),
                        ),
                        Text(
                          expense.isPaid ? "Tak" : "Nie",
                          style: AppTypography.title3.copyWith(
                          color: expense.isPaid ? AppColors.semanticGreen : AppColors.semanticRed,
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
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Opis",
                            style: AppTypography.body1.copyWith(
                              color: AppColors.neutral2,
                            ),
                          ),
                          Text(
                            expense.description,
                            style: AppTypography.title3.copyWith(
                              color: AppColors.neutral3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.only(top: 16, bottom: 48),
                      child:
                        Center(
                          child: Text(
                            "Usuń wydatek",
                            style: AppTypography.body1.copyWith(
                              color: AppColors.semanticRed,
                            ),
                          ),
                        )
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
