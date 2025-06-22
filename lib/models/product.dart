// lib/models/product.dart
class Product {
  int? id;
  String name;
  String description;
  double price;
  int categoryId; // Foreign key to Category table
  String imagePath; // NEW: Added imagePath field

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imagePath, // NEW: Make it required
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imagePath': imagePath, // NEW: Include in map
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      categoryId: map['categoryId'] as int,
      imagePath: map['imagePath'] as String, // NEW: Read from map
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, price: $price, categoryId: $categoryId, imagePath: $imagePath}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id; // Compare by unique ID
  }

  @override
  int get hashCode => id.hashCode;
}
