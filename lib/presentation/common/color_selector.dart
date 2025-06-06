import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/presentation/common/color_selector_tile.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final List<Color> availableColors;
  final Color? selectedColor;
  final Function(Color) onColorSelected;

  const ColorPicker({
    super.key,
    required this.availableColors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: IntrinsicHeight(
          child: Row(
            children: availableColors.map((color) {
              final isSelected = selectedColor == color;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: isSelected
                        ? Border.all(color: AppColors.primary1, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ColorSelectorTile(
                  color: color,
                  isSelected: isSelected,
                  onTap: () {
                    onColorSelected(color);
                  },
                ),
                )
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
