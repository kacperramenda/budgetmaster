import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/presentation/common/color_selector.dart';
import 'package:budgetmaster/presentation/common/input_field.dart';
import 'package:budgetmaster/presentation/common/button_primary.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SafeEditView extends StatefulWidget {
  final Safe safe;

  const SafeEditView({super.key, required this.safe});

  @override
  State<SafeEditView> createState() => _SafeEditViewState();
}

class _SafeEditViewState extends State<SafeEditView> {
  late final TextEditingController _nameController;
  late final TextEditingController _goalAmountController;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.safe.name);
    _goalAmountController = TextEditingController(text: widget.safe.goalAmount.toString());
    selectedColor = widget.safe.color != null 
        ? Color(int.parse(widget.safe.color!))
        : AppColors.primary1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: "Edytuj skarbonkę",
            showAddButton: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                InputField(
                  type: InputType.text,
                  label: "Nazwa skarbonki",
                  placeholder: "Wprowadź nazwę skarbonki",
                  controller: _nameController, 
                  onChanged: (name) {
                    setState(() {
                      name = _nameController.text.trim();
                    });
                  },
                ),
                const SizedBox(height: 16),
                InputField(
                  type: InputType.number,
                  label: "Cel oszczędnościowy",
                  placeholder: "Wprowadź kwotę",
                  controller: _goalAmountController,
                  onChanged: (amount) {
                    setState(() {
                      amount = _goalAmountController.text.trim();
                    });
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
                  label: 'Zapisz zmiany',
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final goalAmount = _goalAmountController.text.trim();
                    final color = selectedColor;

                    if (name.isEmpty || goalAmount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proszę wypełnić wszystkie pola')),
                      );
                      return;
                    }

                    final updatedSafe = widget.safe.copyWith(
                      name: name,
                      goalAmount: double.tryParse(goalAmount) ?? 0.0,
                      color: color.value.toString(),
                    );

                    await context.read<SafeCubit>().updateSafe(updatedSafe);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Zmiany w skarbonce zostały zapisane')),
                    );

                    if (mounted) {
                      Navigator.pop(context, true);
                    }
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