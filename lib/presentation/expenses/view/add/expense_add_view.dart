import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/domain/models/budgetCategory.dart';
import 'package:budgetmaster/presentation/common/buttonPrimary.dart';
import 'package:budgetmaster/presentation/expenses/widgets/add/expense_category_add_tile.dart';
import 'package:budgetmaster/presentation/expenses/widgets/add/expense_category_tile.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/common/InputField.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:provider/provider.dart';
import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';
import 'dart:math';

class ExpenseAddView extends StatefulWidget {
  const ExpenseAddView({super.key});

  @override
  State<ExpenseAddView> createState() => _ExpenseAddViewState();
}

class _ExpenseAddViewState extends State<ExpenseAddView> {
  late String expenseDate;
  late String expenseCategory;
  late String expenseName;
  late String expenseAmount;
  late String expenseDescription;
  BudgetCategory? selectedCategory;
  final colorList = [AppColors.semanticBlue, AppColors.semanticGreen, AppColors.semanticRed, AppColors.semanticYellow];

  @override
  void initState() {
    super.initState();
    expenseDate = DateTime.now().toString();
    expenseCategory = '';
    expenseName = '';
    expenseAmount = '';
    expenseDescription = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: "Dodaj wydatek",
            route: "/expenses",
            showAddButton: true,
            onAddPressed: () {
              Navigator.pushNamed(context, '/add-expense');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Data',
                    placeholder: 'Wybierz datę',
                    value: expenseDate,
                    type: InputType.date,
                    onChanged: (newDate) {
                      setState(() => expenseDate = newDate);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: FutureBuilder<List<BudgetCategory>>(
                    future: Provider.of<BudgetCategoryRepository>(context, listen: false).getAllCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Brak kategorii');
                      }
                      final categories = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ExpenseCategoryAddTile(
                                  onTap: () {
                                    setState(() {
                                      expenseCategory = '';
                                      selectedCategory = null; // ustaw na null jeśli nullable
                                    });
                                  },
                                ),
                              ),
                              ...categories.map((category) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ExpenseCategoryTile(
                                    label: category.name,
                                    backgroundColor: colorList[Random().nextInt(colorList.length)],
                                    onTap: () {
                                      setState(() {
                                        expenseCategory = category.id;
                                        selectedCategory = category;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Nazwa',
                    placeholder: 'Nazwa wydatku',
                    value: expenseName,
                    type: InputType.text,
                    onChanged: (newName) {
                      setState(() => expenseName = newName);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Kwota',
                    placeholder: 'Kwota wydatku',
                    value: expenseAmount,
                    type: InputType.number,
                    onChanged: (newAmount) {
                      setState(() => expenseAmount = newAmount);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InputField(
                    label: 'Opis',
                    placeholder: 'Opis wydatku',
                    value: expenseDescription,
                    type: InputType.number,
                    onChanged: (newAmount) {
                      setState(() => expenseDescription = newAmount);
                    },
                  ),
                ),

                const SizedBox(height: 32),

                ButtonPrimary(
                  label: 'Dodaj',
                  onPressed: () {
                    // wykonaj akcję
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


              