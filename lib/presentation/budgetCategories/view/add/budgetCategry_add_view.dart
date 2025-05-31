import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/domain/models/budgetCategory.dart';
import 'package:budgetmaster/presentation/budgetCategories/cubit/budgetCategory_cubit.dart';
import 'package:budgetmaster/presentation/common/ColorSelector.dart';
import 'package:budgetmaster/presentation/common/InputField.dart';
import 'package:budgetmaster/presentation/common/MonthYearPickerField.dart';
import 'package:budgetmaster/presentation/common/buttonPrimary.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetCategryAddView extends StatefulWidget {
  const BudgetCategryAddView({super.key});

  @override
  State<BudgetCategryAddView> createState() => _BudgetCategryAddView();
}

class _BudgetCategryAddView extends State<BudgetCategryAddView> {
  late String budgetCategoryName;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _monthYearController = TextEditingController();
  Color selectedColor = AppColors.primary1;

  @override
  void initState() {
    super.initState();
    budgetCategoryName = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: "Dodaj kategorię",
            showAddButton: false,
            onAddPressed: () {
              Navigator.pushNamed(context, '/add-budget-category');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                InputField(type: InputType.text,
                  label: "Nazwa kategorii",
                  placeholder: "Wprowadź nazwę kategorii",
                  onChanged: (value) {
                    budgetCategoryName = value;
                  },
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                InputField(type: InputType.number,
                  label: "Budżet",
                  placeholder: "Wprowadź kwotę",
                  onChanged: (value) {
                    // Handle amount change
                  },
                  controller: _amountController,
                ),
                const SizedBox(height: 16),
                MonthYearPickerField(
                  label: 'Miesiąc i rok',
                  placeholder: 'MM/RRRR',
                  controller: _monthYearController,
                  onChanged: (value) {
                    print('Wybrano: $value');
                  },
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
                  label: 'Dodaj',
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final amount = _amountController.text.trim();
                    final monthYear = _monthYearController.text.trim();
                    final color = selectedColor;

                    if (name.isEmpty ||
                        amount.isEmpty ||
                        monthYear.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proszę wypełnić wszystkie pola')),
                      );
                      return;
                    }

                    final parsedMonth = int.tryParse(monthYear.split('/')[0]);
                    final parsedYear = int.tryParse(monthYear.split('/')[1]);

                    await context.read<BudgetCategoryCubit>().addCategory(
                      BudgetCategory(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        startAmount: double.tryParse(amount) ?? 0.0,
                        currentAmount: double.tryParse(amount) ?? 0.0,
                        month: parsedMonth?.toString() ?? '1',
                        year: parsedYear?.toString() ?? DateTime.now().year.toString(),
                        color: color.value.toString(),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kategoria zapisana')),
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
