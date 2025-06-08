import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/models/expense_split.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/presentation/common/button_primary.dart';
import 'package:budgetmaster/presentation/common/input_field.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/split_expense/cubit/expense_split_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseSplitAddView extends StatefulWidget {
  const ExpenseSplitAddView({super.key});

  @override
  State<ExpenseSplitAddView> createState() => _ExpenseSplitAddViewState();
}

class _ExpenseSplitAddViewState extends State<ExpenseSplitAddView> {
  late String name;
  late double amount;
  Expense? expense;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = '';
    amount = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    expense ??= ModalRoute.of(context)!.settings.arguments as Expense;

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
                    label: 'Nazwa',
                    placeholder: 'Nazwa osoby',
                    controller: _nameController,
                    type: InputType.text,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Kwota',
                    placeholder: 'Kwota do zapłaty',
                    controller: _amountController,
                    type: InputType.number,
                    onChanged: (newAmount) => setState(() {
                      if (newAmount.isNotEmpty) {
                        amount = double.tryParse(newAmount) ?? 0.0;
                      } else {
                        amount = 0.0;
                      }
                    },
                  ),
                ),
                ),
                const SizedBox(height: 32),
                ButtonPrimary(
                  label: 'Dodaj',
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final amount = _amountController.text.trim();

                    if (name.isEmpty || amount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proszę wypełnić wszystkie pola')),
                      );
                      return;
                    }

                    final ExpenseSplit split = ExpenseSplit(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      amount: double.parse(amount),
                      expenseId: expense!.id,
                    );

                    await context.read<ExpenseSplitCubit>().addExpenseSplit(split);

                    final updatedExpense = expense!.copyWith(isSplitted: true);
                    await RepositoryProvider.of<ExpenseRepository>(context).updateExpense(updatedExpense);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Podział zapisany')),
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
