/*

SAVING DATABASE REPOSITORY

*/

import 'package:budgetmaster/data/models/isar_saving.dart';
import 'package:budgetmaster/domain/models/saving.dart';
import 'package:budgetmaster/domain/repository/saving_repo.dart';
import 'package:isar/isar.dart';

class IsarSavingRepository implements SavingRepository {
  // Database instance
  final Isar db;

  IsarSavingRepository(this.db);

  // Get all savings
  @override
  Future<List<Saving>> getAllSavings() async {
    final savings = await db.isarSavings.where().findAll();
    return savings.map((isarSaving) => isarSaving.toDomain()).toList();
  }

  // Add a new saving
  @override
  Future<void> addSaving(Saving saving) {
    final isarSaving = IsarSaving.fromDomain(saving);
    return db.writeTxn(() => db.isarSavings.put(isarSaving));
  }

  // Update an existing saving
  @override
  Future<void> updateSaving(Saving saving) {
    final isarSaving = IsarSaving.fromDomain(saving);
    return db.writeTxn(() => db.isarSavings.put(isarSaving));
  }

  // Delete a saving by ID
  @override
  Future<void> deleteSaving(String id) async {
    await db.writeTxn(() => db.isarSavings.delete(int.parse(id)));
  }

  // Get a saving by ID
  @override
  Future<Saving?> getSavingById(String id) async {
    final isarSaving = await db.isarSavings.get(int.parse(id));
    return isarSaving?.toDomain();
  }

  // Delete all savings associated with a specific safe ID
  @override
  Future<void> deleteSavingsBySafeId(String safeId) async {
    final savings = await db.isarSavings.filter().safeIdEqualTo(safeId).findAll();
    if (savings.isNotEmpty) {
      await db.writeTxn(() => db.isarSavings.deleteAll(savings.map((s) => s.id).toList()));
    }
  }
}