import 'package:budgetmaster/data/repository/isar_expense_repository.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/presentation/expenses_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:budgetmaster/data/models/isar_expense.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // get directory path for database
  final directory = await getApplicationDocumentsDirectory();

  // initialize database
  final isar = await Isar.open([IsarExpenseSchema],directory: directory.path,);

  final isarExpenseRepository = IsarExpenseRepository(isar);

  // Add sample data to the database
    final newExpense = IsarExpense()
      ..name = 'Zakupy spożywcze'
      ..category = 'Jedzenie'
      ..date = DateTime.now()
      ..amount = 123.45
      ..description = 'Zakupy w Lidlu'
      ..isSplitted = false
      ..isPaid = true;

  await isar.writeTxn(() async {
    await isar.isarExpenses.put(newExpense); // <- dodaje lub aktualizuje wpis
  });


  // Run app
  runApp(MyApp(expensesRepository: isarExpenseRepository,));
}

class MyApp extends StatelessWidget {
  final ExpenseRepository expensesRepository;

  const MyApp({super.key, required this.expensesRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpensesPage(expensesRepository: expensesRepository),
    );
  }
}