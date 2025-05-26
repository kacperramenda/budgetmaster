import 'package:budgetmaster/presentation/budgetCategories/cubit/budgetCategory_cubit.dart';
import 'package:budgetmaster/presentation/budgetCategories/widgets/budgetCategory_list_item.dart';
import 'package:budgetmaster/presentation/common/monthsScrollList.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetCategoriesView extends StatefulWidget {
  const BudgetCategoriesView({super.key});

  @override
  State<BudgetCategoriesView> createState() => _BudgetCategoriesViewState();
}

class _BudgetCategoriesViewState extends State<BudgetCategoriesView> {
  final List<Map<String, dynamic>> months = [
    {'name': 'Styczeń', 'index': 1},
    {'name': 'Luty', 'index': 2},
    {'name': 'Marzec', 'index': 3},
    {'name': 'Kwiecień', 'index': 4},
    {'name': 'Maj', 'index': 5},
    {'name': 'Czerwiec', 'index': 6},
    {'name': 'Lipiec', 'index': 7},
    {'name': 'Sierpień', 'index': 8},
    {'name': 'Wrzesień', 'index': 9},
    {'name': 'Październik', 'index': 10},
    {'name': 'Listopad', 'index': 11},
    {'name': 'Grudzień', 'index': 12},
  ];

  int? selectedMonthIndex = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BudgetCategoryCubit>().loadCategories();
    });
  }

  void _onMonthSelected(int monthIndex) {
    setState(() {
      selectedMonthIndex = monthIndex;
    });
    context.read<BudgetCategoryCubit>().loadCategories(month: monthIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BudgetCategoryCubit, BudgetCategoryState>(
        builder: (context, state) {
          if (state is BudgetCategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BudgetCategoryLoaded) {
            final categories = state.categories;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: 'Budżet',
                  route: '/home',
                  showAddButton: true,
                  onAddPressed: () async {
                    final result = await Navigator.pushNamed(context, '/add-budget-category');
                    if (result == true) {
                      context.read<BudgetCategoryCubit>().loadCategories(
                        month: selectedMonthIndex,
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: MonthsScrollList(
                    months: months,
                    selectedMonth: selectedMonthIndex,
                    onMonthSelected: _onMonthSelected,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: categories.isEmpty
                        ? const Center(child: Text("Brak kategorii"))
                        : ListView.separated(
                            itemCount: categories.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return BudgetCategoryListItem(budgetCategory: category);
                            },
                          ),
                  ),
                ),
              ],
            );
          }

          if (state is BudgetCategoryError) {
            return Center(child: Text('Błąd: ${state.message}'));
          }

          return const Center(child: Text('Ładowanie danych...'));
        },
      ),
    );
  }
}
