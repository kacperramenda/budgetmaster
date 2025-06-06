import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetmaster/domain/models/budgetCategory.dart';

// States
abstract class BudgetCategoryState extends Equatable {
  const BudgetCategoryState();

  @override
  List<Object?> get props => [];
}

class BudgetCategoryInitial extends BudgetCategoryState {}

class BudgetCategoryLoading extends BudgetCategoryState {}

class BudgetCategoryLoaded extends BudgetCategoryState {
  final List<BudgetCategory> categories;

  const BudgetCategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class BudgetCategoryError extends BudgetCategoryState {
  final String message;

  const BudgetCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class BudgetCategoryCubit extends Cubit<BudgetCategoryState> {
  final BudgetCategoryRepository repository;
  final ExpenseRepository expenseRepository;

  BudgetCategoryCubit(this.repository, this.expenseRepository) : super(BudgetCategoryInitial());
  
  void loadCategories({int? month}) async {
    emit(BudgetCategoryLoading());
    try {
      final all = await repository.getAllCategories(); // lub inna metoda pobierająca dane z bazy
      if(month != -1) {
        final filtered = month != null
            ? all.where((cat) => int.tryParse(cat.month) == month).toList()
            : all;
        emit(BudgetCategoryLoaded(filtered));
      } else {
        emit(BudgetCategoryLoaded(all));
      }
    } catch (e) {
      emit(BudgetCategoryError('Nie udało się załadować kategorii'));
    }
  }

  Future<void> addCategory(BudgetCategory category) async {
    try {
      await repository.addCategory(category);
      // const currentMonth = DateTime.now().month;
      loadCategories(); // Reload categories after adding
    } catch (e) {
      emit(BudgetCategoryError('Nie udało się dodać kategorii'));
    }
  }

  Future<void> updateCategory(BudgetCategory category) async {
    try {
      await repository.updateCategory(category);
      loadCategories(); // Reload categories after updating
    } catch (e) {
      emit(BudgetCategoryError('Nie udało się zaktualizować kategorii'));
    }
  }

  Future<void> deleteCategory(String id) async {
  try {
    final expenses = await expenseRepository.getExpensesByBudgetCategoryId(id);
    if (expenses.isNotEmpty) {
      throw Exception('Nie można usunąć kategorii z dodanymi wydatkami');
    }

    await repository.deleteCategory(id);
    loadCategories(); // Odśwież dane
  } catch (e) {
    rethrow; // Przekaż dalej
  }
}
}
