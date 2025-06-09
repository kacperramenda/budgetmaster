/*

SAVING REPOSITORY

*/

import 'package:budgetmaster/domain/models/saving.dart';

abstract class SavingRepository  {
  // Get all savings
  Future<List<Saving>> getAllSavings();

  // Add a new saving
  Future<void> addSaving(Saving saving);

  // Update an existing saving
  Future<void> updateSaving(Saving saving);

  // Delete a saving by ID
  Future<void> deleteSaving(String id);

  // Get a saving by ID
  Future<Saving?> getSavingById(String id);

  // Delete all savings associated with a specific safe ID
  Future<void> deleteSavingsBySafeId(String safeId);
}