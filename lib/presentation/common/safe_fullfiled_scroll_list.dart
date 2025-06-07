import 'package:flutter/material.dart';

class SafeFullfiledScrollList extends StatelessWidget {
  final Function(int monthIndex) onStateSelected;
  final List<String> states;
  final int selectedState;

  const SafeFullfiledScrollList({
    super.key,
    required this.onStateSelected,
    required this.states,
    required this.selectedState,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: states.map((state) {
            final bool isSelected = states.indexOf(state) == selectedState;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onStateSelected(states.indexOf(state)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3629B7) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    state.toString(),
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
