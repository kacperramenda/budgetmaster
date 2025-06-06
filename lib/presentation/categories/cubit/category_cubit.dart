import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/repository/category_repo.dart';
import 'package:budgetmaster/domain/repository/expense_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:budgetmaster/domain/models/category.dart';

// States
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository repository;
  final ExpenseRepository expenseRepository;

  CategoryCubit(this.repository, this.expenseRepository) : super(CategoryInitial());
  
  void loadCategories({int? month}) async {
    emit(CategoryLoading());
    try {
      final all = await repository.getAllCategories(); // lub inna metoda pobierająca dane z bazy
      if(month != -1) {
        final filtered = month != null
            ? all.where((cat) => int.tryParse(cat.month) == month).toList()
            : all;
        emit(CategoryLoaded(filtered));
      } else {
        emit(CategoryLoaded(all));
      }
    } catch (e) {
      emit(CategoryError('Nie udało się załadować kategorii'));
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await repository.addCategory(category);
      // const currentMonth = DateTime.now().month;
      loadCategories(); // Reload categories after adding
    } catch (e) {
      emit(CategoryError('Nie udało się dodać kategorii'));
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await repository.updateCategory(category);
      loadCategories(); // Reload categories after updating
    } catch (e) {
      emit(CategoryError('Nie udało się zaktualizować kategorii'));
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
