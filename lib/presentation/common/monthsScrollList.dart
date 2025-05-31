import 'package:flutter/material.dart';

class MonthsScrollList extends StatelessWidget {
  final List<Map<String, dynamic>> months;
  final int? selectedMonth;
  final Function(int monthIndex) onMonthSelected;

  const MonthsScrollList({
    super.key,
    required this.months,
    required this.onMonthSelected,
    this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: months.map((month) {
            final String monthName = month['name'] as String;
            final int monthIndex = month['index'] as int;
            final bool isSelected = monthIndex == selectedMonth;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onMonthSelected(monthIndex),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3629B7) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    monthName,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
