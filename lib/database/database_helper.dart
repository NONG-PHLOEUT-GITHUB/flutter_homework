// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final _databaseName = "MyStore.db";
  static final _databaseVersion =
      1; // You might increment this to 2 if you handle upgrade

  // Table names
  static final tableCategory = 'categories';
  static final tableProduct = 'products';
  static final tableOrder = 'orders';
  static final tableOrderItem = 'order_items';

  // Category table columns
  static final columnCategoryId = 'id';
  static final columnCategoryName = 'name';
  static final columnCategoryDescription = 'description';

  // Product table columns
  static final columnProductId = 'id';
  static final columnProductName = 'name';
  static final columnProductDescription = 'description';
  static final columnProductPrice = 'price';
  static final columnProductCategoryId = 'categoryId'; // Foreign key
  static final columnProductImagePath =
      'imagePath'; // NEW: New column for image path

  // Order table columns
  static final columnOrderId = 'id';
  static final columnOrderTotalAmount = 'totalAmount';
  static final columnOrderDate = 'orderDate';

  // OrderItem table columns
  static final columnOrderItemId = 'id';
  static final columnOrderItemOrderId = 'orderId'; // Foreign key
  static final columnOrderItemProductId = 'productId'; // Foreign key
  static final columnOrderItemQuantity = 'quantity';
  static final columnOrderItemPrice = 'price';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database or create it if it doesn't exist
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add onUpgrade for future schema changes
    );
  }

  // SQL code to create the database tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableCategory (
            $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnCategoryName TEXT NOT NULL,
            $columnCategoryDescription TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableProduct (
            $columnProductId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnProductName TEXT NOT NULL,
            $columnProductDescription TEXT NOT NULL,
            $columnProductPrice REAL NOT NULL,
            $columnProductCategoryId INTEGER NOT NULL,
            $columnProductImagePath TEXT NOT NULL, -- NEW: Add this line
            FOREIGN KEY ($columnProductCategoryId) REFERENCES $tableCategory ($columnCategoryId) ON DELETE CASCADE
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableOrder (
            $columnOrderId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnOrderTotalAmount REAL NOT NULL,
            $columnOrderDate TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableOrderItem (
            $columnOrderItemId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnOrderItemOrderId INTEGER NOT NULL,
            $columnOrderItemProductId INTEGER NOT NULL,
            $columnOrderItemQuantity INTEGER NOT NULL,
            $columnOrderItemPrice REAL NOT NULL,
            FOREIGN KEY ($columnOrderItemOrderId) REFERENCES $tableOrder ($columnOrderId) ON DELETE CASCADE,
            FOREIGN KEY ($columnOrderItemProductId) REFERENCES $tableProduct ($columnProductId) ON DELETE CASCADE
          )
          ''');
  }

  // Handle database upgrades (e.g., adding new tables or columns)
  // For this change, you might just delete and recreate the DB in development.
  // In production, you'd handle schema migration here.
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Example: if (oldVersion < 2) { await db.execute("ALTER TABLE $tableProduct ADD COLUMN $columnProductImagePath TEXT"); }
    print("Database upgrade from version $oldVersion to $newVersion");
  }

  // Helper method to delete the database (useful for development/testing)
  Future<void> deleteDatabaseFile() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    if (await databaseFactory.databaseExists(path)) {
      await deleteDatabase(path);
      _database = null; // Reset the database instance
      print("Database file deleted: $path");
    }
  }
}
