import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/domain/repository/safe_repo.dart';
import 'package:budgetmaster/domain/repository/saving_repo.dart';

class SafeState {
  final List<Safe> safes;
  final String selectedSafe;

  SafeState({
    required this.safes,
    this.selectedSafe = '0',
  });
}

class SafeCubit extends Cubit<SafeState> {
  final SafeRepository safeRepo;
  final SavingRepository savingRepo;

  SafeCubit(this.safeRepo, this.savingRepo)
      : super(SafeState(safes: [], selectedSafe: '0')) {
    loadSafes();
  }

  Future<void> loadSafes() async {
    final safes = await safeRepo.getAllSafes();
    emit(SafeState(safes: safes, selectedSafe: state.selectedSafe));
  }

  // Add safe
  Future<void> addSafe(Safe safe) async {
    await safeRepo.addSafe(safe);
    await loadSafes();
  }

  // Update safe
  Future<void> updateSafe(Safe safe) async {
    await safeRepo.updateSafe(safe);
    await loadSafes();
  }

  // Delete safe
  Future<void> deleteSafe(String id) async {
    await safeRepo.deleteSafe(id);
    await loadSafes();
  }

  // Get safe by state
  Future<void> getSafesByState(int selectedSafe) async {
    if (selectedSafe == 0) {
      final safes = await safeRepo.getAllSafes();
      emit(SafeState(safes: safes, selectedSafe: '0'));
      return;
    }
    final isFullfiled = selectedSafe == 1;
    final safes = await safeRepo.getSafesByState(isFullfiled);
    emit(SafeState(safes: safes, selectedSafe: selectedSafe.toString()));
  }

  // Get safe by ID
  Future<Safe?> getSafeById(String id) async {
    return await safeRepo.getSafeById(id);
  }

  // Get safe name by ID
  Future<String> getSafeNameById(String id) async {
    final safe = await safeRepo.getSafeById(id);
    return safe?.name ?? 'Nieznana skarbonka';
  }

  // Aktualizacja currentAmount i isFullfiled dla wszystkich sejfów
  Future<void> updateSafeAmounts() async {
    final allSavings = await savingRepo.getAllSavings();
    final safes = await safeRepo.getAllSafes();

    for (final safe in safes) {
      final savingsForSafe = allSavings.where((s) => s.safeId == safe.id).toList();
      final currentAmount = savingsForSafe.fold(0.0, (sum, s) => sum + s.amount);
      final isFullfiled = currentAmount >= safe.goalAmount;

      final updatedSafe = safe.copyWith(
        currentAmount: currentAmount,
        isFullfiled: isFullfiled,
      );

      await safeRepo.updateSafe(updatedSafe);
    }

    // Odśwież stan po aktualizacji
    await loadSafes();
  }
}
