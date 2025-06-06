import 'package:budgetmaster/presentation/expenses_set/cubit/expenses_set_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/common/month_tile.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/common/years_scroll_list.dart';

class ExpensesSetView extends StatelessWidget {
  const ExpensesSetView({super.key});

  final List<Map<String, dynamic>> months = const [
    {'name': 'Wszystkie', 'index': 0},
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesSetCubit, ExpensesSetState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'Zestawienie wydatków',
                route: '/home',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: YearsScrollList(
                  years: state.availableYears,
                  selectedYear: state.selectedYear,
                  onYearSelected: (year) {
                    context.read<ExpensesSetCubit>().selectYear(year);
                  },
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  padding: const EdgeInsets.all(16),
                  children: months.map((month) {
                    return MonthTile(
                      onTap: () {
                        final monthIndex = month['index'] as int;
                        final expenses = context.read<ExpensesSetCubit>().getExpensesForMonth(monthIndex);
                        Navigator.pushNamed(
                          context,
                          '/expenses-set-month',
                          arguments: {
                            'expenses': expenses,
                            'categories': state.budgetCategories,
                            'selectedMonth': month,
                          },
                        );
                      },
                      monthName: month['name'],
                      monthNumber: month['index'],
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
