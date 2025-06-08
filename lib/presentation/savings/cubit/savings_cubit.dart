import 'package:bloc/bloc.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/domain/models/saving.dart';
import 'package:budgetmaster/domain/repository/safe_repo.dart';
import 'package:budgetmaster/domain/repository/saving_repo.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavingsState {
  final List<Saving> savings;
  final List<Safe> safes;
  late String? selectedSafe;

  SavingsState({
    required this.savings,
    required this.safes,
    this.selectedSafe = '0',
  });
}

class SavingsCubit extends Cubit<SavingsState> {
  final SavingRepository savingRepo;
  final SafeRepository safesRepo;

  SavingsCubit(this.savingRepo, this.safesRepo)
      : super(SavingsState(savings: [], safes: [], selectedSafe: '0')) {
    loadData();
  }

  Future<void> loadData() async {
    await loadSafes();
    await loadSavings();
  }

  Future<void> loadSafes() async {
    final safes = await safesRepo.getAllSafes();
    safes.insert(0, Safe(id: '0', name: 'Wszystkie', goalAmount: 0.0, isFullfiled: false));
    emit(SavingsState(savings: state.savings, safes: safes, selectedSafe: state.selectedSafe));
  }

  Future<void> loadSavings() async {
    final savings = await savingRepo.getAllSavings();
    emit(SavingsState(savings: savings, safes: state.safes, selectedSafe: state.selectedSafe));
  }

  Future<void> addSaving(Saving saving, BuildContext context) async {
    await savingRepo.addSaving(saving);
    await context.read<SafeCubit>().updateSafeAmounts();
    await loadData();
  }

  Future<void> updateSaving(Saving saving, BuildContext context) async {
    await savingRepo.updateSaving(saving);
    await context.read<SafeCubit>().updateSafeAmounts();
    await loadData();
  }

  Future<void> deleteSaving(String id, BuildContext context) async {
    final saving = await savingRepo.getSavingById(id);
    if (saving == null) return;
    await savingRepo.deleteSaving(id);
    await context.read<SafeCubit>().updateSafeAmounts();
    await loadData();
  }

  Future<List<Saving>> getSavingsBySafeId(String safeId) async {
    final savings = await savingRepo.getAllSavings();
    return savings.where((s) => s.safeId == safeId).toList();
  }
}
