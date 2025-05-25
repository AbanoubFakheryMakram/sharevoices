import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/controllers/audio_controller.dart';
import 'package:sharevoices/main.dart';
import 'package:sharevoices/models/category_model.dart';
import 'package:sharevoices/models/record_model.dart';
import 'package:sharevoices/services/database/database_services.dart';

final crudOperationsProvider = ChangeNotifierProvider<CRUDOperations>((ref) => CRUDOperations());

class CRUDOperations extends ChangeNotifier {
  List<RecordModel> records = [];
  List<CategoryModel> categories = [];
  bool loading = false;

  void readRecords(int categoryId) async {
    records = [];
    setLoading(true);
    final databaseServices = providerContainer.read(databaseServicesProvider);
    final data = await databaseServices.readData(
      'SELECT * FROM ${databaseServices.recordsTable} WHERE category_id = $categoryId',
    );

    for (final record in data) {
      final currentRecord = RecordModel.fromMap(record);
      if (await File(currentRecord.recordPath).exists()) {
        final audioPlayer = providerContainer.read(audioController).audioPlayer;
        await audioPlayer.setSourceDeviceFile(currentRecord.recordPath);
        final duration = await audioPlayer.getDuration();
        currentRecord.duration = duration;
        records.add(currentRecord);
      } else {
        await deleteRecord(currentRecord.id!, categoryId);
      }
    }

    setLoading(false);
  }

  void setLoading(bool state) {
    loading = state;
    notifyListeners();
  }

  Future<void> readCategories() async {
    categories = [];
    final databaseServices = providerContainer.read(databaseServicesProvider);
    final data = await databaseServices.readData('SELECT * FROM ${databaseServices.categoriesTable}');

    for (final category in data) {
      categories.add(CategoryModel.fromMap(category));
    }

    notifyListeners();
  }

  Future<void> deleteRecord(int id, int categoryId) async {
    final databaseServices = providerContainer.read(databaseServicesProvider);
    await databaseServices.deleteData('DELETE FROM ${databaseServices.recordsTable} WHERE id = $id');
    readRecords(categoryId);
  }

  Future<void> deleteCategory(int id) async {
    final databaseServices = providerContainer.read(databaseServicesProvider);
    await databaseServices.deleteData('DELETE FROM ${databaseServices.categoriesTable} WHERE id = $id');
    await readCategories();
  }

  Future<void> createCategory(String avatar, String name) async {
    final databaseServices = providerContainer.read(databaseServicesProvider);
    await databaseServices.insertData(
      'INSERT INTO ${databaseServices.categoriesTable} (category_avatar, category_name) VALUES ("$avatar", "$name")',
    );
    await readCategories();
  }

  Future<void> updateCategory(String name, int id) async {
    final databaseServices = providerContainer.read(databaseServicesProvider);
    await databaseServices.updateData(
      '''
        UPDATE ${databaseServices.categoriesTable}
        SET category_name = '$name'
        WHERE id = $id''',
    );
    await readCategories();
  }

  Future<void> insertRecord(String path, String name, int categoryId) async {
    final databaseServices = providerContainer.read(databaseServicesProvider);
    await databaseServices.insertData(
      'INSERT INTO ${databaseServices.recordsTable} (record_path, record_name, category_id) VALUES ("$path", "$name", $categoryId)',
    );
  }

  Future<void> updateRecord(String newName, int recordId, int categoryId) async {
    final databaseServices = providerContainer.read(databaseServicesProvider);
    await databaseServices.updateData(
      '''
        UPDATE ${databaseServices.recordsTable}
        SET record_name = '$newName', category_id = $categoryId
        WHERE id = $recordId''',
    );
  }
}
