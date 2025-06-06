import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/domain/repository/category_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';

class ExpensesSetState {
  final int selectedYear;
  final List<int> availableYears;
  final List<Expense> expenses;
  final List<Category> categories;

  ExpensesSetState({
    required this.selectedYear,
    required this.availableYears,
    required this.expenses,
    required this.categories,
  });

  ExpensesSetState copyWith({
    int? selectedYear,
    List<int>? availableYears,
    List<Expense>? expenses,
    List<Category>? budgetCategories,
  }) {
    return ExpensesSetState(
      selectedYear: selectedYear ?? this.selectedYear,
      availableYears: availableYears ?? this.availableYears,
      expenses: expenses ?? this.expenses,
      categories: budgetCategories ?? this.categories,
    );
  }
}

class ExpensesSetCubit extends Cubit<ExpensesSetState> {
  final ExpenseRepository _repository;
  final CategoryRepository budgetCategoryRepository;

  ExpensesSetCubit(this._repository, this.budgetCategoryRepository)
      : super(ExpensesSetState(
          selectedYear: DateTime.now().year,
          availableYears: [],
          expenses: [],
          categories: [],
        )) {
    _init();
  }

  Future<void> _init() async {
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (index) => currentYear - index);
    emit(state.copyWith(availableYears: years));
    final categories = await budgetCategoryRepository.getAllCategories(); // lub inny repo
    emit(state.copyWith(budgetCategories: categories));
    loadExpensesForYear(state.selectedYear);
  }

  void selectYear(int year) {
    emit(state.copyWith(selectedYear: year));
    loadExpensesForYear(year);
  }

  Future<void> loadExpensesForYear(int year) async {
    final expenses = await _repository.getExpensesForYear(year);
    emit(state.copyWith(expenses: expenses));
  }

  List<Expense> getExpensesForMonth(int monthIndex) {
    if (monthIndex == 0) return state.expenses;
    return state.expenses.where((e) => e.date.month == monthIndex).toList();
  }
}
