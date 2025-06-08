import 'package:budgetmaster/domain/models/safe.dart';
import 'package:flutter/material.dart';

class SafesScrollList extends StatelessWidget {
  final Function(String safeId) onSafeSelected;
  final String? selectedSafe;
  final List<Safe> safes;

  const SafesScrollList({
    super.key,
    required this.onSafeSelected,
    required this.selectedSafe,
    required this.safes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: safes.map((safe) {
            final isSelected = safe.id == selectedSafe;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onSafeSelected(safe.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3629B7) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    safe.name,
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
