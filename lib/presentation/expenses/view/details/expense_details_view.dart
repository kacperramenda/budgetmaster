import 'dart:io';

import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/presentation/common/page_header.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';

String _formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}

class ExpenseDetailsView extends StatefulWidget {
  final String expenseId;

  const ExpenseDetailsView({super.key, required this.expenseId});

  @override
  State<ExpenseDetailsView> createState() => _ExpenseDetailsViewState();
}

class _ExpenseDetailsViewState extends State<ExpenseDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseCubit>().reloadExpense(widget.expenseId);
  }

  Future<File> _checkIfFileExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
    throw Exception("File not found");
  }

  void _showFullScreenImage(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.file(imageFile),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        final expense = state.expenses.firstWhere(
          (e) => e.id == widget.expenseId,
          orElse: () => Expense(
            id: '',
            name: '',
            amount: 0.0,
            date: DateTime.now(),
            categoryId: '',
            isSplitted: false,
            isPaid: false,
            description: '',
          ),
        );

        if (expense.id == '') {
          return const Scaffold(
            body: Center(child: Text("Wydatek nie znaleziony")),
          );
        }

        final category = state.budgetCategories.firstWhere(
          (c) => c.id == expense.categoryId,
          orElse: () => Category(
            id: '',
            name: 'Nieznana kategoria',
            startAmount: 0.0,
            currentAmount: 0.0,
            month: DateTime.now().month.toString(),
            year: DateTime.now().year.toString(),
          ),
        );

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
                  child: SingleChildScrollView(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kategoria",
                                style: AppTypography.body1.copyWith(
                                  color: AppColors.neutral2,
                                ),
                              ),
                              Text(
                                category.name,
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
                          child: Row(
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
                    
                        if (expense.isSplitted)
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
                    
                        if (expense.isSplitted)
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
                                  "Kwota opłacona",
                                  style: AppTypography.body1.copyWith(
                                    color: AppColors.neutral2,
                                  ),
                                ),
                                Text(
                                  "${expense.paidAmount.toStringAsFixed(2)} zł",
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
                                expense.description,
                                style: AppTypography.title3.copyWith(
                                  color: AppColors.neutral3,
                                ),
                              ),
                            ],
                          ),
                        ),
                    
                        if (expense.receiptImagePath != null && expense.receiptImagePath!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Załączony paragon",
                                  style: AppTypography.body1.copyWith(
                                    color: AppColors.neutral2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FutureBuilder<File>(
                                  future: _checkIfFileExists(expense.receiptImagePath!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    
                                    if (!snapshot.hasData || snapshot.data == null) {
                                      return Text(
                                        "Zdjęcie nie zostało znalezione",
                                        style: AppTypography.body1.copyWith(color: AppColors.semanticRed),
                                      );
                                    }
                                    
                                    return GestureDetector(
                                      onTap: () => _showFullScreenImage(context, snapshot.data!),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          snapshot.data!,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                    
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
                                  title: Text("Potwierdzenie", style: AppTypography.title2),
                                  content: Text("Czy na pewno chcesz usunąć ten wydatek?", style: AppTypography.body3.copyWith(
                                    color: AppColors.neutral1,
                                  )),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text("Anuluj", style: TextStyle(
                                        color: AppColors.primary1,
                                      ),
                                    ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text("Usuń", style: TextStyle(
                                        color: AppColors.semanticRed,
                                      )),
                                    ),
                                  ],
                                ),
                              );
                    
                              if (confirm == true) {
                                if (!context.mounted) return;
                                await context.read<ExpenseCubit>().deleteExpense(expense.id);
                                if (!context.mounted) return;
                                Navigator.pop(context, true); 
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 48),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        "Podziel wydatek",
                                        style: AppTypography.body1.copyWith(
                                          color: AppColors.primary1,
                                        ),
                                      ),
                                      onTap: () async {
                                        await Navigator.pushNamed(
                                          context,
                                          '/split-expense',
                                          arguments: expense,
                                        ).then((result) {
                                          if (result == true) {
                                            context.read<ExpenseCubit>().reloadExpense(expense.id);
                                          }
                                        });
                                      }
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Usuń wydatek",
                                      style: AppTypography.body1.copyWith(
                                        color: AppColors.semanticRed,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
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
