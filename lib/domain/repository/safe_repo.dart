/*

SAFE REPOSITORY

*/

import 'package:budgetmaster/domain/models/safe.dart';

abstract class SafeRepository {
  // Add a new safe
  Future<void> addSafe(Safe safe);

  // Update an existing safe
  Future<void> updateSafe(Safe safe);

  // Delete a safe by ID
  Future<void> deleteSafe(String id);

  // Get a safe by ID
  Future<Safe?> getSafeById(String id);

  // Get all safes
  Future<List<Safe>> getAllSafes();

  // Get safes by state (fullfiled or not)
  Future<List<Safe>> getSafesByState(bool isFullfiled);
}
