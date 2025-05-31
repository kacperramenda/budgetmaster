import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/repository/budgetCategory_repo.dart';
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

  BudgetCategoryCubit(this.repository) : super(BudgetCategoryInitial());
  
  void loadCategories({int? month}) async {
    emit(BudgetCategoryLoading());
    try {
      final all = await repository.getAllCategories(); // lub inna metoda pobierająca dane z bazy
      final filtered = month != null
          ? all.where((cat) => int.tryParse(cat.month) == month).toList()
          : all;
      emit(BudgetCategoryLoaded(filtered));
    } catch (e) {
      emit(BudgetCategoryError('Nie udało się załadować kategorii'));
    }
  }
}
