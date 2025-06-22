// lib/services/order_service.dart
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class OrderService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Insert an order and its items
  Future<int> createOrder(Order order, List<OrderItem> items) async {
    Database db = await _dbHelper.database;
    int orderId = await db.insert(
      DatabaseHelper.tableOrder,
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (var item in items) {
      item.orderId = orderId; // Link item to the newly created order
      await db.insert(
        DatabaseHelper.tableOrderItem,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return orderId;
  }

  // Get all orders
  Future<List<Order>> getOrders() async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableOrder);
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  // Get a single order by ID with its items
  Future<Map<String, dynamic>?> getOrderWithItems(int orderId) async {
    Database db = await _dbHelper.database;

    // Get the order
    final List<Map<String, dynamic>> orderMaps = await db.query(
      DatabaseHelper.tableOrder,
      where: '${DatabaseHelper.columnOrderId} = ?',
      whereArgs: [orderId],
    );

    if (orderMaps.isEmpty) {
      return null;
    }

    final Order order = Order.fromMap(orderMaps.first);

    // Get order items
    final List<Map<String, dynamic>> itemMaps = await db.query(
      DatabaseHelper.tableOrderItem,
      where: '${DatabaseHelper.columnOrderItemOrderId} = ?',
      whereArgs: [orderId],
    );

    final List<OrderItem> orderItems = List.generate(itemMaps.length, (i) {
      return OrderItem.fromMap(itemMaps[i]);
    });

    return {
      'order': order,
      'items': orderItems,
    };
  }

  // Update an order (e.g., total amount, date)
  Future<int> updateOrder(Order order) async {
    Database db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableOrder,
      order.toMap(),
      where: '${DatabaseHelper.columnOrderId} = ?',
      whereArgs: [order.id],
    );
  }

  // Delete an order (and its associated order items due to CASCADE)
  Future<int> deleteOrder(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableOrder,
      where: '${DatabaseHelper.columnOrderId} = ?',
      whereArgs: [id],
    );
  }
}