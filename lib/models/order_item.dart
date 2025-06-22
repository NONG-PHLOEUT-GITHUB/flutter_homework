class OrderItem {
  int? id;
  int orderId; // Foreign key to Order table
  int productId; // Foreign key to Product table
  int quantity;
  double price; // Price at the time of order

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as int?,
      orderId: map['orderId'] as int,
      productId: map['productId'] as int,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
    );
  }

  @override
  String toString() {
    return 'OrderItem{id: $id, orderId: $orderId, productId: $productId, quantity: $quantity, price: $price}';
  }
}
