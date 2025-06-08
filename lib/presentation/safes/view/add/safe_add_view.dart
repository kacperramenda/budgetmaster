import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/presentation/categories/cubit/category_cubit.dart';
import 'package:budgetmaster/presentation/common/color_selector.dart';
import 'package:budgetmaster/presentation/common/input_field.dart';
import 'package:budgetmaster/presentation/common/month_year_picker_field.dart';
import 'package:budgetmaster/presentation/common/button_primary.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SafeAddView extends StatefulWidget {
  const SafeAddView({super.key});

  @override
  State<SafeAddView> createState() => _SafeAddView();
}

class _SafeAddView extends State<SafeAddView> {
  late String budgetCategoryName;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalAmountController = TextEditingController();
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
            title: "Dodaj skarbonkę",
            showAddButton: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                InputField(type: InputType.text,
                  label: "Nazwa skarbonki",
                  placeholder: "Wprowadź nazwę skarbonki",
                  onChanged: (value) {
                    budgetCategoryName = value;
                  },
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                InputField(type: InputType.number,
                  label: "Cel oszczędnościowy",
                  placeholder: "Wprowadź kwotę",
                  onChanged: (value) {
                    // Handle amount change
                  },
                  controller: _goalAmountController,
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
                    final goalAmount = _goalAmountController.text.trim();
                    final color = selectedColor;

                    if (name.isEmpty ||
                        goalAmount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proszę wypełnić wszystkie pola')),
                      );
                      return;
                    }

                    await context.read<SafeCubit>().addSafe(
                      Safe(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        goalAmount: double.tryParse(goalAmount) ?? 0.0,
                        color: color.value.toString(),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Skarbonka utworzona pomyślnie')),
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
