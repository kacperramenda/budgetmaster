/*

SAFE DATABASE REPOSITORY

*/

import 'package:budgetmaster/data/models/isar_safe.dart';
import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/domain/repository/safe_repo.dart';
import 'package:isar/isar.dart';

class IsarSafeRepository implements SafeRepository {
  // Database instance
  final Isar db;

  IsarSafeRepository(this.db);

  // Get all safes
  @override
  Future<List<Safe>> getAllSafes() async {
    final safes = await db.isarSafes.where().findAll();
    return safes.map((isarSafe) => isarSafe.toDomain()).toList();
  }

  // Add a new safe
  @override
  Future<void> addSafe(Safe safe) {
    final isarSafe = IsarSafe.fromDomain(safe);
    return db.writeTxn(() => db.isarSafes.put(isarSafe));
  }

  // Update an existing safe
  @override
  Future<void> updateSafe(Safe safe) {
    final isarSafe = IsarSafe.fromDomain(safe);
    return db.writeTxn(() => db.isarSafes.put(isarSafe));
  }

  // Delete a safe by ID
  @override
  Future<void> deleteSafe(String id) async {
    await db.writeTxn(() => db.isarSafes.delete(int.parse(id)));
  }

  // Get a safe by ID
  @override
  Future<Safe?> getSafeById(String id) async {
    final isarSafe = await db.isarSafes.get(int.parse(id));
    return isarSafe?.toDomain();
  }

  // Get safes by state (fullfiled or not)
  @override
  Future<List<Safe>> getSafesByState(bool isFullfiled) async {
    final safes = await db.isarSafes
        .filter()
        .isFulfilledEqualTo(isFullfiled)
        .findAll();
    return safes.map((isarSafe) => isarSafe.toDomain()).toList();
  }
}

