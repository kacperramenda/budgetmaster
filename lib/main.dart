import 'package:budgetmaster/data/repository/isar_expense_repository.dart';
import 'package:budgetmaster/data/repository/isar_budgetCategory_repository.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';
import 'package:budgetmaster/presentation/budgetCategories/cubit/budgetCategory_cubit.dart';
import 'package:budgetmaster/presentation/common/main_scaffold.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:budgetmaster/presentation/expenses/view/add/expense_add_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:budgetmaster/data/models/isar_expense.dart';
import 'package:budgetmaster/data/models/isar_budgetCategory.dart';
import 'package:budgetmaster/presentation/expenses/view/details/expense_details_view.dart';
import 'package:budgetmaster/domain/models/expense.dart';

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

  // add sample expenses
  final newExpense = IsarExpense()
    ..id = 2
    ..name = 'Zakupy spożywcze'
    ..amount = 250.0
    ..budgetCategoryId = '2'
    ..date = DateTime.now()
    ..description = 'Zakupy w sklepie spożywczym'
    ..isPaid = false
    ..isSplitted = false;

  await isar.writeTxn(() async {
    await isar.isarExpenses.put(newExpense);
  });

  // delete all expenses
  // await isar.writeTxn(() async {
  //   final allExpenseIds = await isar.isarExpenses.where().idProperty().findAll();
  //   await isar.isarExpenses.deleteAll(allExpenseIds);
  // });

  // print expenses from database in terminal
  final expenses = await isarExpenseRepository.getAllExpenses();
  for (var expense in expenses) {
    print('Expense: ID: ${expense.id}, Name: ${expense.name}, Amount: ${expense.amount}, Category: ${expense.budgetCategoryId}, Date: ${expense.date}');
  }


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
        BlocProvider<ExpenseCubit>(
          create: (context) => ExpenseCubit(expensesRepository, budgetCategoryRepository),
        ),
        BlocProvider<BudgetCategoryCubit>(
          create: (context) => BudgetCategoryCubit(budgetCategoryRepository),
        ),
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
          '/expense_details': (context) {
            final expense = ModalRoute.of(context)!.settings.arguments as Expense;
            return ExpenseDetailsView(expense: expense);
          },
          '/add-expense': (context) => const ExpenseAddView(),
        },
      ),
    );
  }
}
