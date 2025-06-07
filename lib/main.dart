import 'package:budgetmaster/data/models/isar_safe.dart';
import 'package:budgetmaster/data/repository/isar_expense_repository.dart';
import 'package:budgetmaster/data/repository/isar_category_repository.dart';
import 'package:budgetmaster/data/repository/isar_safe_repository.dart';
import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/domain/repository/category_repo.dart';
import 'package:budgetmaster/domain/repository/safe_repo.dart';
import 'package:budgetmaster/presentation/categories/cubit/category_cubit.dart';
import 'package:budgetmaster/presentation/categories/view/add/categry_add_view.dart';
import 'package:budgetmaster/presentation/categories/view/details/category_details_view.dart';
import 'package:budgetmaster/presentation/common/main_scaffold.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:budgetmaster/presentation/expenses/view/add/expense_add_view.dart';
import 'package:budgetmaster/presentation/expenses_set/cubit/expenses_set_cubit.dart';
import 'package:budgetmaster/presentation/expenses_set/view/expenses_set_month_view.dart';
import 'package:budgetmaster/presentation/expenses_set/view/expenses_set_view.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';
import 'package:budgetmaster/presentation/safes/view/add/safe_add_view.dart';
import 'package:budgetmaster/presentation/safes/view/details/safe_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:budgetmaster/data/models/isar_expense.dart';
import 'package:budgetmaster/data/models/isar_category.dart';
import 'package:budgetmaster/presentation/expenses/view/details/expense_details_view.dart';
import 'package:budgetmaster/domain/models/expense.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get directory path for database
  final directory = await getApplicationDocumentsDirectory();

  // Initialize database
  final isar = await Isar.open(
    [IsarExpenseSchema, IsarCategorySchema, IsarSafeSchema],
    directory: directory.path,
  );

  final isarExpenseRepository = IsarExpenseRepository(isar);
  final isarBudgetCategoryRepository = IsarCategoryRepository(isar);
  final isarSafeRepository = IsarSafeRepository(isar);

  // add sample budget categories
  // final newBudgetCategory = IsarBudgetCategory()
  //   ..id = 4
  //   ..name = 'Inne'
  //   ..startAmount = 500.0
  //   ..currentAmount = 500.0
  //   ..month = '5'
  //   ..year = '2025'
  //   ..color = '0xFFFFAF2A'; // Example color in ARGB format

  // await isar.writeTxn(() async {
  //   await isar.isarBudgetCategorys.put(newBudgetCategory); 
  // });

  // delete all budget categories
  // await isar.writeTxn(() async {
  //   final allCategoryIds = await isar.isarBudgetCategorys.where().idProperty().findAll();
  //   await isar.isarBudgetCategorys.deleteAll(allCategoryIds);
  // });

  // delete budget categories with id 
  // await isar.writeTxn(() async {
  //   await isar.isarBudgetCategorys.delete(1);
  // });

  // add sample expenses
  // final newExpense = IsarExpense()
  //   ..id = 2
  //   ..name = 'Zakupy spożywcze'
  //   ..amount = 250.0
  //   ..budgetCategoryId = '2'
  //   ..date = DateTime.now()
  //   ..description = 'Zakupy w sklepie spożywczym'
  //   ..isPaid = false
  //   ..isSplitted = false;

  // await isar.writeTxn(() async {
  //   await isar.isarExpenses.put(newExpense);
  // });

  // delete all expenses
  // await isar.writeTxn(() async {
  //   final allExpenseIds = await isar.isarExpenses.where().idProperty().findAll();
  //   await isar.isarExpenses.deleteAll(allExpenseIds);
  // });

  // delete all safes
  // await isar.writeTxn(() async {
  //   final allSafeIds = await isar.isarSafes.where().idProperty().findAll();
  //   await isar.isarSafes.deleteAll(allSafeIds);
  // });

  // add sample fulfilled safe
  // final newSafe = IsarSafe()
  //   ..id = 15
  //   ..name = 'Bezpieczna kwota'
  //   ..goalAmount = 1000.0
  //   ..currentAmount = 1000.0
  //   ..color = '0xFF00FF00' // Example color in ARGB format
  //   ..isFulfilled = true;
  // await isar.writeTxn(() async {
  //   await isar.isarSafes.put(newSafe);
  // });


  // print expenses from database in terminal
  final expenses = await isarExpenseRepository.getAllExpenses();
  for (var expense in expenses) {
    print('Expense: ID: ${expense.id}, Name: ${expense.name}, Amount: ${expense.amount}, Category: ${expense.categoryId}, Date: ${expense.date}');
  }


  // Run app
  runApp(MyApp(
    expensesRepository: isarExpenseRepository,
    budgetCategoryRepository: isarBudgetCategoryRepository,
    safeRepository: isarSafeRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ExpenseRepository expensesRepository;
  final CategoryRepository budgetCategoryRepository;
  final SafeRepository safeRepository;

  const MyApp({
    super.key,
    required this.expensesRepository,
    required this.budgetCategoryRepository,
    required this.safeRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ExpenseRepository>.value(value: expensesRepository),
        Provider<CategoryRepository>.value(value: budgetCategoryRepository),
        BlocProvider<ExpenseCubit>(
          create: (context) => ExpenseCubit(expensesRepository, budgetCategoryRepository),
        ),
        BlocProvider<CategoryCubit>(
          create: (context) => CategoryCubit(budgetCategoryRepository, expensesRepository),
        ),
        BlocProvider<ExpensesSetCubit>(
          create: (context) => ExpensesSetCubit(expensesRepository, budgetCategoryRepository),
        ),
        BlocProvider<SafeCubit>(
          create: (context) => SafeCubit(safeRepository),
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
          '/budget-categories': (context) => const MainScaffold(currentIndex: 1),
          '/safes': (context) => const MainScaffold(currentIndex: 2),
          '/expenses': (context) => const MainScaffold(currentIndex: 3),
          '/expense_details': (context) {
            final expense = ModalRoute.of(context)!.settings.arguments as Expense;
            return ExpenseDetailsView(expense: expense);
          },
          '/add-expense': (context) => const ExpenseAddView(),
          '/add-budget-category': (context) => const CategoryAddView(),
          '/budget-category-details': (context) {
            final category = ModalRoute.of(context)!.settings.arguments as Category;
            return CategoryDetailsView(category: category);
          },
          '/expenses-set' : (context) {
            return ExpensesSetView();
          },
          '/expenses-set-month': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            final expenses = args['expenses'] as List<Expense>;
            final categories = args['categories'] as List<Category>;
            final selectedMonth = args['selectedMonth'];
            return ExpensesSetMonthView(
              expenses: expenses,
              categories: categories,
              selectedMonth: selectedMonth,
            );
          },
          '/add-safe': (context) => const SafeAddView(),
          '/safe-details': (context) {
            final safe = ModalRoute.of(context)!.settings.arguments as Safe;
            return SafeDetailsView(safe: safe);
          },
        },
      ),
    );
  }
}
