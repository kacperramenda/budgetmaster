import 'package:budgetmaster/presentation/categories/cubit/category_cubit.dart';
import 'package:budgetmaster/presentation/categories/widgets/category_list_item.dart';
import 'package:budgetmaster/presentation/common/months_scroll_list.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final List<Map<String, dynamic>> months = [
    {'name': 'Wszystkie', 'index': -1},
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
      context.read<CategoryCubit>().loadCategories(month: selectedMonthIndex);
    });
  }

  void _onMonthSelected(int monthIndex) {
    setState(() {
      selectedMonthIndex = monthIndex;
    });
    context.read<CategoryCubit>().loadCategories(month: monthIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryLoaded) {
            final categories = state.categories;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: 'Kategorie',
                  route: '/home',
                  showAddButton: true,
                  onAddPressed: () async {
                    final result = await Navigator.pushNamed(context, '/add-budget-category');
                    if (result == true) {
                      context.read<CategoryCubit>().loadCategories(
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
                  child: categories.isEmpty
                      ? const Center(child: Text('Brak kategorii'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final month = months.firstWhere((m) => m['index'] == int.parse(category.month), orElse: () => {'name': 'Nieznany miesiąc'})['name'];
                            return CategoryListItem(budgetCategory: category, showMonth: selectedMonthIndex == -1 ? true : false, month: month);
                          },
                        ),
                ),
              ],
            );
          }

          if (state is CategoryError) {
            return Center(child: Text('Błąd: ${state.message}'));
          }

          return const Center(child: Text('Ładowanie danych...'));
        },
      ),
    );
  }
}
