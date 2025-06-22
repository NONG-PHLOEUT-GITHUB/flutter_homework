// lib/services/product_service.dart
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/product.dart';

class ProductService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Insert a product
  Future<int> insertProduct(Product product) async {
    Database db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.tableProduct,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableProduct);
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Get products by category ID
  Future<List<Product>> getProductsByCategoryId(int categoryId) async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableProduct,
      where: '${DatabaseHelper.columnProductCategoryId} = ?',
      whereArgs: [categoryId],
    );
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Get a single product by ID
  Future<Product?> getProductById(int id) async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableProduct,
      where: '${DatabaseHelper.columnProductId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  // Update a product
  Future<int> updateProduct(Product product) async {
    Database db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableProduct,
      product.toMap(),
      where: '${DatabaseHelper.columnProductId} = ?',
      whereArgs: [product.id],
    );
  }

  // Delete a product
  Future<int> deleteProduct(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableProduct,
      where: '${DatabaseHelper.columnProductId} = ?',
      whereArgs: [id],
    );
  }
}
