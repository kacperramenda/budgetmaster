import 'package:flutter/material.dart';
import 'package:budgetmaster/domain/models/budgetCategory.dart';

class ExpensesCategoryScrollList extends StatelessWidget {
  final List<BudgetCategory> categories;
  final String? selectedCategory;
  final Function(String category) onCategorySelected;

  const ExpensesCategoryScrollList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategory = '1',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = category.id == selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onCategorySelected(category.name),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3629B7) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category.name,
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
