import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

enum InputType { text, number, date, monthYear }

class InputField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final InputType type;
  final void Function(String) onChanged;
  final TextEditingController? controller;

  const InputField({
    super.key,
    this.label,
    this.placeholder,
    required this.type,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
            child: Text(
              label!,
              style: AppTypography.caption1.copyWith(
                color: AppColors.neutral3,
              ),
            ),
          ),
        ],
        GestureDetector(
          onTap: () async {
            if (type == InputType.date) {
              DateTime initialDate = DateTime.now();
              if (effectiveController.text.isNotEmpty) {
                try {
                  initialDate = DateFormat('dd/MM/yyyy').parse(effectiveController.text);
                } catch (_) {}
              }
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: AppColors.primary1,
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary1,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                      dialogTheme: DialogThemeData(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        titleTextStyle: AppTypography.title2,
                        contentTextStyle: AppTypography.body1,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary1,
                          textStyle: AppTypography.body1,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                final formatted = DateFormat('dd/MM/yyyy').format(pickedDate);
                effectiveController.text = formatted;
                onChanged(formatted);
              }
            }

            if (type == InputType.monthYear) {
              final now = DateTime.now();
              final picked = await showMonthYearPicker(
                context: context,
                initialDate: now,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                locale: const Locale("pl"), // jeśli chcesz PL
              );

              if (picked != null) {
                final formatted = '${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                effectiveController.text = formatted;
                onChanged(formatted);
              }
            }
          },

          child: AbsorbPointer(
            absorbing: type == InputType.date || type == InputType.monthYear,
            child: TextField(
              controller: effectiveController,
              keyboardType: _getKeyboardType(),
              onChanged: onChanged,
              style: AppTypography.body3.copyWith(
                color: AppColors.neutral1,
              ),
              decoration: InputDecoration(
                hintText: placeholder ?? '',
                hintStyle: AppTypography.body3.copyWith(
                  color: AppColors.neutral3,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neutral3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neutral3),
                ),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextInputType _getKeyboardType() {
    switch (type) {
      case InputType.number:
        return TextInputType.number;
      case InputType.text:
      case InputType.date:
      default:
        return TextInputType.text;
    }
  }
}