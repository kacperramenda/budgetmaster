import 'package:flutter/material.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';

class MonthYearPickerField extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const MonthYearPickerField({
    super.key,
    this.label,
    this.placeholder,
    this.controller,
    this.onChanged,
  });

  @override
  State<MonthYearPickerField> createState() => _MonthYearPickerFieldState();
}

class _MonthYearPickerFieldState extends State<MonthYearPickerField> {
  final _internalController = TextEditingController();
  late TextEditingController _controller;

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? _internalController;
  }

  void _showMonthYearDialog(BuildContext context) async {
    int tempMonth = selectedMonth;
    int tempYear = selectedYear;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Wybierz miesiąc i rok',
            style: AppTypography.title2.copyWith(
              color: AppColors.neutral1,
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    value: tempMonth,
                    items: List.generate(12, (index) {
                      final month = index + 1;
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month.toString().padLeft(2, '0')),
                      );
                    }),
                    dropdownColor: Colors.white,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          tempMonth = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<int>(
                    value: tempYear,
                    items: List.generate(30, (index) {
                      final year = 2000 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    dropdownColor: Colors.white,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          tempYear = value;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                selectedMonth = tempMonth;
                selectedYear = tempYear;
                final formatted =
                    '${selectedMonth.toString().padLeft(2, '0')}/${selectedYear.toString()}';
                _controller.text = formatted;
                widget.onChanged?.call(formatted);
                Navigator.of(ctx).pop();
              },
              child: Text(
                'OK',
                style: AppTypography.body1.copyWith(
                  color: AppColors.primary1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
            child: Text(
              widget.label!,
              style: AppTypography.caption1.copyWith(
                color: AppColors.neutral3,
              ),
            ),
          ),
        GestureDetector(
          onTap: () => _showMonthYearDialog(context),
          child: AbsorbPointer(
            child: TextField(
              controller: _controller,
              style: AppTypography.body3.copyWith(
                color: AppColors.neutral1,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder ?? '',
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
}
