import 'package:budgetmaster/data/repository/isar_expense_repository.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/presentation/common/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  // // Add sample data to the database
  //   final newExpense = IsarExpense()
  //     ..name = 'Zakupy spożywcze'
  //     ..category = 'Jedzenie'
  //     ..date = DateTime.now()
  //     ..amount = 123.45
  //     ..description = 'Zakupy w Lidlu'
  //     ..isSplitted = false
  //     ..isPaid = true;

  //   await isar.writeTxn(() async {
  //     await isar.isarExpenses.put(newExpense); // <- dodaje lub aktualizuje wpis
  //   });


  // Run app
  runApp(MyApp(expensesRepository: isarExpenseRepository,));
}

class MyApp extends StatelessWidget {
  final ExpenseRepository expensesRepository;

  const MyApp({super.key, required this.expensesRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: expensesRepository,
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
