import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/expenses/widgets/expense_list_item.dart';
import 'package:budgetmaster/presentation/expenses/widgets/expenses_header.dart';
import 'package:budgetmaster/presentation/expenses/widgets/expenses_category_scroll_list.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ExpensesHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: ExpensesCategoryScrollList(
                  categories: state.budgetCategories,
                  onCategorySelected: (selectedCategory) {
                    // Update the selected category in the state
                  },
                ),
              ),
              // Lista wydatków
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
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/expense_details',
                                arguments: expense,
                              );
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
