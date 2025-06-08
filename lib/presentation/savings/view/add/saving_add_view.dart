import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/presentation/common/button_primary.dart';
import 'package:budgetmaster/presentation/common/input_field.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/expenses/widgets/add/expense_category_add_tile.dart';
import 'package:budgetmaster/presentation/expenses/widgets/add/expense_category_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/savings/cubit/savings_cubit.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';
import 'package:budgetmaster/domain/models/saving.dart';

class SavingAddView extends StatefulWidget {
  const SavingAddView({super.key});

  @override
  State<SavingAddView> createState() => _SavingAddViewState();
}

class _SavingAddViewState extends State<SavingAddView> {
  late String savingDate;
  late String savingSafeId;
  late String savingAmount;
  late String savingDescription;
  Safe? selectedSafe;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    savingDate = '';
    savingSafeId = '';
    savingAmount = '';
    savingDescription = '';
    context.read<SafeCubit>().loadSafes(); // upewnij się, że są załadowane
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(title: "Dodaj oszczędność"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Data',
                    placeholder: 'Wybierz datę',
                    type: InputType.date,
                    controller: _dateController,
                    onChanged: (newDate) => setState(() => savingDate = newDate),
                  ),
                ),

                BlocBuilder<SafeCubit, SafeState>(
                  builder: (context, state) {
                    final safes = [
                      Safe(id: '0', name: 'Wszystkie', goalAmount: 0.0, isFullfiled: false),
                      ...state.safes,
                    ];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ExpenseCategoryAddTile(
                                  onTap: () async {
                                    await Navigator.pushNamed(context, '/add-safe');
                                    context.read<SafeCubit>().loadSafes(); // odśwież sejfy po powrocie
                                  },
                                ),
                              ),
                              ...safes.skip(1).map((safe) {
                                final isSelected = selectedSafe?.id == safe.id;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: isSelected
                                          ? Border.all(color: AppColors.primary1, width: 2)
                                          : null,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ExpenseCategoryTile(
                                      label: safe.name,
                                      backgroundColor: safe.color != null
                                          ? Color(int.parse(safe.color!))
                                          : AppColors.primary1,
                                      onTap: () {
                                        setState(() {
                                          savingSafeId = safe.id;
                                          selectedSafe = safe;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Nazwa',
                    placeholder: 'Nazwa oszczędności',
                    controller: _nameController,
                    type: InputType.text,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Kwota',
                    placeholder: 'Kwota oszczędności',
                    controller: _amountController,
                    type: InputType.number,
                    onChanged: (newAmount) => setState(() => savingAmount = newAmount),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Opis',
                    placeholder: 'Opis oszczędności',
                    controller: _descriptionController,
                    type: InputType.text,
                    onChanged: (newDesc) => setState(() => savingDescription = newDesc),
                  ),
                ),
                const SizedBox(height: 32),
                ButtonPrimary(
                  label: 'Dodaj',
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final amount = _amountController.text.trim();
                    final desc = _descriptionController.text.trim();
                    final date = _dateController.text.trim();

                    if (date.isEmpty || savingSafeId.isEmpty || name.isEmpty || amount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proszę wypełnić wszystkie pola')),
                      );
                      return;
                    }

                    DateTime? parsedDate;
                    try {
                      final parts = date.split('/');
                      parsedDate = DateTime(
                        int.parse(parts[2]),
                        int.parse(parts[1]),
                        int.parse(parts[0]),
                      );
                    } catch (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nieprawidłowy format daty')),
                      );
                      return;
                    }

                    final saving = Saving(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      amount: double.tryParse(amount) ?? 0.0,
                      description: desc,
                      date: parsedDate,
                      safeId: savingSafeId,
                    );

                    await context.read<SavingsCubit>().addSaving(saving, context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Oszczędność zapisana')),
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
