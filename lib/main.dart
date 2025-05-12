import 'package:budgetmaster/data/repository/isar_expense_repository.dart';
import 'package:budgetmaster/data/repository/isar_budgetCategory_repository.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';
import 'package:budgetmaster/presentation/common/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:budgetmaster/data/models/isar_expense.dart';
import 'package:budgetmaster/data/models/isar_budgetCategory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get directory path for database
  final directory = await getApplicationDocumentsDirectory();

  // Initialize database
  final isar = await Isar.open(
    [IsarExpenseSchema, IsarBudgetCategorySchema],
    directory: directory.path,
  );

  final isarExpenseRepository = IsarExpenseRepository(isar);
  final isarBudgetCategoryRepository = IsarCategoryRepository(isar);

  // add sample budget categories
  // final newBudgetCategory = IsarBudgetCategory()
  //   ..id = 4
  //   ..name = 'Rozrywka'
  //   ..startAmount = 350.0
  //   ..currentAmount = 250.0
  //   ..month = '5'
  //   ..year = '2025';

  // await isar.writeTxn(() async {
  //   await isar.isarBudgetCategorys.put(newBudgetCategory); 
  // });

  // Run app
  runApp(MyApp(
    expensesRepository: isarExpenseRepository,
    budgetCategoryRepository: isarBudgetCategoryRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ExpenseRepository expensesRepository;
  final BudgetCategoryRepository budgetCategoryRepository;

  const MyApp({
    super.key,
    required this.expensesRepository,
    required this.budgetCategoryRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ExpenseRepository>.value(value: expensesRepository),
        Provider<BudgetCategoryRepository>.value(value: budgetCategoryRepository),
      ],
      child: MaterialApp(
        title: 'BudgetMaster',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.blue,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const MainScaffold(currentIndex: 0),
          '/budget': (context) => const MainScaffold(currentIndex: 1),
          '/savings': (context) => const MainScaffold(currentIndex: 2),
          '/expenses': (context) => const MainScaffold(currentIndex: 3),
        },
      ),
    );
  }
}
