/*

SAFE CUBIT

Each cubit is a list of safes.

*/

import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/domain/repository/safe_repo.dart';

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

  SafeCubit(this.safeRepo)
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
    loadSafes();
  }

  // Update safe
  Future<void> updateSafe(Safe safe) async {
    await safeRepo.updateSafe(safe);
    loadSafes();
  }

  // Delete safe
  Future<void> deleteSafe(String id) async {
    await safeRepo.deleteSafe(id);
    loadSafes();
  }

  // Get safe by state
  Future<void> getSafesByState(int selectedSafe) async {
    // 0 - All, 1 - Fullfiled, 2 - Unfullfiled
    if(selectedSafe == 0) {
      // If selected state is 0, get all safes
      final safes = await safeRepo.getAllSafes();
      emit(SafeState(safes: safes, selectedSafe: '0'));
      return;
    }
    final isFullfiled = selectedSafe == 1;
    final safes = await safeRepo.getSafesByState(isFullfiled);
    emit(SafeState(safes: safes, selectedSafe: selectedSafe.toString()));
  }
}