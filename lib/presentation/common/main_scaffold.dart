import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:budgetmaster/presentation/budgetCategories/view/budgetCategories_view.dart';
import 'package:budgetmaster/presentation/common/customBottomNav.dart';
import 'package:budgetmaster/presentation/expenses/view/expenses_page.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/home/view/home_view.dart';
import 'package:provider/provider.dart';
import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';

class MainScaffold extends StatefulWidget {
  final int currentIndex;

  const MainScaffold({super.key, required this.currentIndex});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  void _onTabTapped(int index) {
    if (index == widget.currentIndex) return;

    String route;
    switch (index) {
      case 0:
        route = '/home';
        break;
      case 1:
        route = '/budget';
        break;
      case 2:
        route = '/savings';
        break;
      case 3:
        route = '/expenses';
        break;
      default:
        route = '/home';
    }

    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(widget.currentIndex),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: widget.currentIndex,
        onTabSelected: _onTabTapped,
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return BudgetCategoriesView();
      case 2:
        return const HomeView();
      case 3:
          return ExpensesPage(
            expensesRepository: context.read<ExpenseRepository>(),
            budgetCategoryRepository: context.read<BudgetCategoryRepository>(),
          );
      default:
        return const HomeView();
    }
  }
}
