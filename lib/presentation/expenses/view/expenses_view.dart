import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/expenses/widgets/expense_list_item.dart';
import 'package:budgetmaster/presentation/expenses/widgets/expenses_category_scroll_list.dart';


class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Wydatki',
                route: '/home',
                showAddButton: true,
                onAddPressed: () async {
                  final result = await Navigator.pushNamed(context, '/add-expense');
                  if (result == true) {
                    // ignore: use_build_context_synchronously
                    context.read<ExpenseCubit>().loadExpenses();
                  }
                }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: ExpensesCategoryScrollList(
                  categories: state.budgetCategories,
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: (selectedCategory) {
                    context.read<ExpenseCubit>().selectCategory(selectedCategory);
                  },
                ),
              ),
              // Expenses list
              Expanded(
                child: state.expenses.isEmpty
                    ? const Center(child: Text('Brak wydatków'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = state.expenses[index];
                          return ExpenseListItem(
                            expense: expense,
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                '/expense_details',
                                arguments: expense,
                              );

                              if (result == true) {
                                // odśwież listę wydatków
                                context.read<ExpenseCubit>().loadExpenses();
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
