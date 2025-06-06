import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/expenses_set/widget/expenses_set_list_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpensesSetMonthView extends StatelessWidget {
  final List<Expense> expenses;
  final List<Category> categories;
  final Map<String, dynamic> selectedMonth;

  const ExpensesSetMonthView({
    super.key,
    required this.expenses,
    required this.categories,
    required this.selectedMonth,
  });

  Map<String, List<Expense>> _groupExpensesByDay(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};
    for (var expense in expenses) {
      final dayKey = DateFormat('dd.MM.yyyy').format(expense.date);
      grouped.putIfAbsent(dayKey, () => []).add(expense);
    }
    return grouped;
  }

  Map<String, double> _groupExpensesByCategory(List<Expense> expenses) {
    final Map<String, double> grouped = {};
    for (var expense in expenses) {
      grouped.update(
        expense.categoryId,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return grouped;
  }

  double _calculateTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  Category _getCategoryById(String id) {
    return categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => Category(id: id, name: 'Inna', startAmount: 0, currentAmount: 0, month: '', year: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedExpenses = _groupExpensesByDay(expenses);
    final groupedByCategory = _groupExpensesByCategory(expenses);
    final total = _calculateTotal(expenses);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(title: 'Zestawienie ${selectedMonth['name']}', route: '/expenses-set'),
          const SizedBox(height: 16),

          // Wykres kołowy
          if (groupedByCategory.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: groupedByCategory.entries.map((entry) {
                    final percentage = entry.value / total * 100;
                    final category = _getCategoryById(entry.key);
                    return PieChartSectionData(
                      value: entry.value,
                      title: '${percentage.toStringAsFixed(1)}%',
                      color: Color(int.parse(category.color ?? '0xff000000')),
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Legenda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: groupedByCategory.keys.map((categoryId) {
                  final category = _getCategoryById(categoryId);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(int.parse(category.color ?? '0xff000000')),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(selectedMonth['index'] == 0 ? '${category.name} (${_monthNameFromNumber(category.month)})' : category.name, style: AppTypography.body3),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Lista wydatków
          Expanded(
            child: groupedExpenses.isEmpty
                ? const Center(child: Text('Brak wydatków w tym miesiącu'))
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: groupedExpenses.entries.map((entry) {
                      final date = entry.key;
                      final dailyExpenses = entry.value;
                      final dayTotal = _calculateTotal(dailyExpenses);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: AppTypography.body3.copyWith(color: AppColors.neutral3),
                          ),
                          ...dailyExpenses.map(
                            (expense) {
                              final category = _getCategoryById(expense.categoryId);
                              return ExpensesSetListItem(
                                expense: expense,
                                categoryName: selectedMonth['index'] == 0
                                  ? '${category.name} (${_monthNameFromNumber(category.month)})'
                                  : category.name, // nowy parametr
                                onTap: () {
                                  Navigator.pushNamed(context, '/expense_details', arguments: expense);
                                },
                              );
                            },
                          ).toList(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Łącznie: ${dayTotal.toStringAsFixed(2)} PLN',
                              style: AppTypography.body3.copyWith(color: AppColors.neutral3),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

_monthNameFromNumber(String month) {
  switch (month) {
    case '1':
      return 'Styczeń';
    case '2':
      return 'Luty';
    case '3':
      return 'Marzec';
    case '4':
      return 'Kwiecień';
    case '5':
      return 'Maj';
    case '6':
      return 'Czerwiec';
    case '7':
      return 'Lipiec';
    case '8':
      return 'Sierpień';
    case '9':
      return 'Wrzesień';
    case '10':
      return 'Październik';
    case '11':
      return 'Listopad';
    case '12':
      return 'Grudzień';
    default:
      return '';
  }
}
