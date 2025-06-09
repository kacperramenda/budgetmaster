import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/presentation/categories/cubit/category_cubit.dart';
import 'package:budgetmaster/presentation/common/color_selector.dart';
import 'package:budgetmaster/presentation/common/input_field.dart';
import 'package:budgetmaster/presentation/common/month_year_picker_field.dart';
import 'package:budgetmaster/presentation/common/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryEditView extends StatefulWidget {
  final Category category;

  const CategoryEditView({super.key, required this.category, required String categoryId});

  @override
  State<CategoryEditView> createState() => _CategoryEditViewState();
}

class _CategoryEditViewState extends State<CategoryEditView> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _monthYearController;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _amountController = TextEditingController(
        text: widget.category.startAmount.toStringAsFixed(2));
    _monthYearController = TextEditingController(
        text:
            '${widget.category.month.padLeft(2, '0')}/${widget.category.year}');
    selectedColor = Color(int.parse(widget.category.color ?? AppColors.primary1.value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: "Edytuj kategorię",
            showAddButton: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                InputField(
                  type: InputType.text,
                  label: "Nazwa kategorii",
                  placeholder: "Wprowadź nazwę kategorii",
                  controller: _nameController, 
                  onChanged: (String ) { 
                    // Optional: Handle changes if needed
                  },
                ),
                const SizedBox(height: 16),
                InputField(
                  type: InputType.number,
                  label: "Budżet",
                  placeholder: "Wprowadź kwotę",
                  controller: _amountController,
                  onChanged: (String value) {
                    // Optional: Handle changes if needed
                  },
                ),
                const SizedBox(height: 16),
                MonthYearPickerField(
                  label: 'Miesiąc i rok',
                  placeholder: 'MM/RRRR',
                  controller: _monthYearController,
                ),
                const SizedBox(height: 16),
                ColorPicker(
                  availableColors: [
                    AppColors.primary1,
                    AppColors.semanticBlue,
                    AppColors.semanticGreen,
                    AppColors.semanticYellow,
                    AppColors.semanticOrange,
                    AppColors.semanticRed
                  ],
                  selectedColor: selectedColor,
                  onColorSelected: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
                const SizedBox(height: 32),
                ButtonPrimary(
                  label: 'Zapisz zmiany',
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final amount = _amountController.text.trim();
                    final monthYear = _monthYearController.text.trim();

                    if (name.isEmpty ||
                        amount.isEmpty ||
                        monthYear.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Proszę wypełnić wszystkie pola')),
                      );
                      return;
                    }

                    final parsedMonth = int.tryParse(monthYear.split('/')[0]);
                    final parsedYear = int.tryParse(monthYear.split('/')[1]);
                    final oldStart = widget.category.startAmount;
                    final oldCurrent = widget.category.currentAmount;
                    final spent = oldStart - oldCurrent;

                    final newStart = double.tryParse(amount) ?? oldStart;
                    final newCurrent = newStart - spent;

                    final updatedCategory = widget.category.copyWith(
                      name: name,
                      startAmount: double.tryParse(amount) ?? 0.0,
                      currentAmount: newCurrent,
                      month: parsedMonth?.toString() ?? '1',
                      year: parsedYear?.toString() ??
                          DateTime.now().year.toString(),
                      color: selectedColor.value.toString(),
                    );

                    await context
                        .read<CategoryCubit>()
                        .updateCategory(updatedCategory);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Zaktualizowano kategorię')),
                    );
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
