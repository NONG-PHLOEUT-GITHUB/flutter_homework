// lib/services/category_service.dart
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/category.dart';

class CategoryService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Insert a category
  Future<int> insertCategory(Category category) async {
    Database db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.tableCategory,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all categories
  Future<List<Category>> getCategories() async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableCategory);
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  // Get a single category by ID
  Future<Category?> getCategoryById(int id) async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableCategory,
      where: '${DatabaseHelper.columnCategoryId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }

  // Update a category
  Future<int> updateCategory(Category category) async {
    Database db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableCategory,
      category.toMap(),
      where: '${DatabaseHelper.columnCategoryId} = ?',
      whereArgs: [category.id],
    );
  }

  // Delete a category
  Future<int> deleteCategory(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableCategory,
      where: '${DatabaseHelper.columnCategoryId} = ?',
      whereArgs: [id],
    );
  }
}

