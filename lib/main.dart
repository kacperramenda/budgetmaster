import 'package:budgetmaster/data/models/isar_expense_split.dart';
import 'package:budgetmaster/data/models/isar_safe.dart';
import 'package:budgetmaster/data/models/isar_saving.dart';
import 'package:budgetmaster/data/repository/isar_expense_repository.dart';
import 'package:budgetmaster/data/repository/isar_category_repository.dart';
import 'package:budgetmaster/data/repository/isar_expense_split_repository.dart';
import 'package:budgetmaster/data/repository/isar_safe_repository.dart';
import 'package:budgetmaster/data/repository/isar_saving_repository.dart';
import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/domain/models/saving.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/domain/repository/category_repo.dart';
import 'package:budgetmaster/domain/repository/expense_split_repo.dart';
import 'package:budgetmaster/domain/repository/safe_repo.dart';
import 'package:budgetmaster/domain/repository/saving_repo.dart';
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
import 'package:budgetmaster/presentation/savings/cubit/savings_cubit.dart';
import 'package:budgetmaster/presentation/savings/view/add/saving_add_view.dart';
import 'package:budgetmaster/presentation/savings/view/details/saving_details_view.dart';
import 'package:budgetmaster/presentation/savings/view/savings_view.dart';
import 'package:budgetmaster/presentation/split_expense/add/expense_split_add_view.dart';
import 'package:budgetmaster/presentation/split_expense/cubit/expense_split_cubit.dart';
import 'package:budgetmaster/presentation/split_expense/view/expense_split_page.dart';
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
    [IsarExpenseSchema, IsarCategorySchema, IsarSafeSchema, IsarSavingSchema, IsarExpenseSplitSchema],
    directory: directory.path,
  );

  final isarExpenseRepository = IsarExpenseRepository(isar);
  final isarBudgetCategoryRepository = IsarCategoryRepository(isar);
  final isarSafeRepository = IsarSafeRepository(isar);
  final isarSavingsRepository = IsarSavingRepository(isar); 
  final isarExpenseSplitRepository = IsarExpenseSplitRepository(isar);

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
  //   ..color = '0xFF0890FE' // Example color in ARGB format
  //   ..isFulfilled = true;
  // await isar.writeTxn(() async {
  //   await isar.isarSafes.put(newSafe);
  // });


  // delete all savings
  // await isar.writeTxn(() async {
  //   final allSavingIds = await isar.isarSavings.where().idProperty().findAll();
  //   await isar.isarSavings.deleteAll(allSavingIds);
  // });

  // print expenses from database in terminal
  // final expenses = await isarExpenseRepository.getAllExpenses();
  // for (var expense in expenses) {
  //   print('Expense: ID: ${expense.id}, Name: ${expense.name}, Amount: ${expense.amount}, Category: ${expense.categoryId}, Date: ${expense.date}');
  // }

  // delete all expense splits
  // await isar.writeTxn(() async {
  //   final allExpenseSplitIds = await isar.isarExpenseSplits.where().idProperty().findAll();
  //   await isar.isarExpenseSplits.deleteAll(allExpenseSplitIds);
  // });

  // update all expenses to not split and not paid and paid amount to 0.0
  // await isar.writeTxn(() async {
  //   final allExpenseIds = await isar.isarExpenses.where().idProperty().findAll();
  //   for (var id in allExpenseIds) {
  //     final expense = await isar.isarExpenses.get(id);
  //     if (expense != null) {
  //       expense.isSplitted = false;
  //       expense.isPaid = false;
  //       expense.paidAmount = 0.0;
  //       await isar.isarExpenses.put(expense);
  //     }
  //   }
  // });

  // update category where id is '1749245000802' to have currentAmount 400.0
  // await isar.writeTxn(() async {
  //   final category = await isar.isarCategorys.get(1749245000802);
  //   if (category != null) {
  //     category.currentAmount = 0.0;
  //     category.startAmount = 700.0; // Update startAmount if needed
  //     await isar.isarCategorys.put(category);
  //   }
  // }); 
  // print all categories from database in terminal
  // final categories = await isarBudgetCategoryRepository.getAllCategories();
  // for (var category in categories) {
  //   print('Category: ID: ${category.id}, Name: ${category.name}, Start Amount: ${category.startAmount}, Current Amount: ${category.currentAmount}, Month: ${category.month}, Year: ${category.year}');
  // }


  // Run app
  runApp(MyApp(
    expensesRepository: isarExpenseRepository,
    budgetCategoryRepository: isarBudgetCategoryRepository,
    safeRepository: isarSafeRepository,
    savingsRepository: isarSavingsRepository,
    expenseSplitRepository: isarExpenseSplitRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ExpenseRepository expensesRepository;
  final CategoryRepository budgetCategoryRepository;
  final SafeRepository safeRepository;
  final SavingRepository savingsRepository;
  final ExpenseSplitRepository expenseSplitRepository;

  const MyApp({
    super.key,
    required this.expensesRepository,
    required this.budgetCategoryRepository,
    required this.safeRepository,
    required this.savingsRepository,
    required this.expenseSplitRepository,
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
          create: (context) => SafeCubit(safeRepository, savingsRepository),
        ),
        BlocProvider<SavingsCubit>(
          create: (context) => SavingsCubit(savingsRepository, safeRepository),
        ),
        Provider<ExpenseSplitRepository>.value(value: expenseSplitRepository),
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
          '/add-expense': (context) => const ExpenseAddView(),
          '/add-budget-category': (context) => const CategoryAddView(),
          '/budget-category-details': (context) {
            final category = ModalRoute.of(context)!.settings.arguments as Category;
            return CategoryDetailsView(categoryId: category.id);
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
            return SafeDetailsView(safeId: safe.id);
          },
          '/savings': (context) {
            return const SavingsView();
          },
          '/add-saving': (context) {
            return SavingAddView();
          },
          '/saving-details': (context) {
            final saving = ModalRoute.of(context)!.settings.arguments as Saving;
            return SavingDetailsView(savingId: saving.id);
          },
          '/split-expense': (context) => const ExpenseSplitPage(),
          '/expense-split-add': (context) {
            final repo = RepositoryProvider.of<ExpenseSplitRepository>(context);

            return BlocProvider(
              create: (context) => ExpenseSplitCubit(repo),
              child: ExpenseSplitAddView(),
            );
          },
          '/expense_details': (context) {
            final expense = ModalRoute.of(context)!.settings.arguments as Expense;
            return ExpenseDetailsView(expenseId: expense.id);
          },
        },
      ),
    );
  }
}
