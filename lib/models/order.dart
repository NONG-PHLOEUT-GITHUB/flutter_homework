// lib/models/order.dart
class Order {
  int? id;
  double totalAmount;
  String orderDate; // Stored as ISO 8601 string, e.g., "2023-10-27T10:00:00.000Z"

  Order({this.id, required this.totalAmount, required this.orderDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'orderDate': orderDate,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int?,
      totalAmount: map['totalAmount'] as double,
      orderDate: map['orderDate'] as String,
    );
  }

  @override
  String toString() {
    return 'Order{id: $id, totalAmount: $totalAmount, orderDate: $orderDate}';
  }
}