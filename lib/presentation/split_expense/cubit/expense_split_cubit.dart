import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/models/expense_split.dart';
import 'package:budgetmaster/domain/repository/expense_split_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseSplitState {
  final List<ExpenseSplit> splits;

  ExpenseSplitState({
    required this.splits,
  });
}

class ExpenseSplitCubit extends Cubit<ExpenseSplitState> {
  final ExpenseSplitRepository expenseSplitRepository;

  ExpenseSplitCubit(this.expenseSplitRepository)
      : super(ExpenseSplitState(splits: [])) {
    loadExpenseSplits();
  }

  Future<void> loadExpenseSplits() async {
    final splits = await expenseSplitRepository.getAllExpenseSplits();
    emit(ExpenseSplitState(splits: splits));
  }

  Future<void> addExpenseSplit(ExpenseSplit split) async {
    await expenseSplitRepository.addExpenseSplit(split);
    // update expense isSplitted property after adding a split
    if (split.expenseId != null) {
      await expenseSplitRepository.updateExpenseState(split.expenseId!);
    }
    await loadExpenseSplits();
  }

  Future<void> updateExpenseSplit(ExpenseSplit split) async {
    await expenseSplitRepository.updateExpenseSplit(split);
    // update expesnse state after updating a split
    if (split.expenseId != null) {
      await expenseSplitRepository.updateExpenseState(split.expenseId!);
    }
    await loadExpenseSplits();
  }

  Future<void> deleteExpenseSplit(String id) async {
    final split = await expenseSplitRepository.getExpenseSplitById(id);
    await expenseSplitRepository.deleteExpenseSplit(id);
    // update expense isSplitted property after deleting a split
    if (split != null && split.expenseId != null) {
      await expenseSplitRepository.updateExpenseState(split.expenseId!);
    }
    await loadExpenseSplits();
  }

  Future<void> getExpenseSplitsForExpense(String expenseId) async {
    final splits = await expenseSplitRepository.getAllExpenseSplitsForExpense(expenseId);
    emit(ExpenseSplitState(splits: splits));
  }
}
