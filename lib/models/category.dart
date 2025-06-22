// lib/models/category.dart
class Category {
  int? id;
  String name;
  String description;

  Category({this.id, required this.name, required this.description});

  // Convert a Category object into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  // Convert a Map into a Category object.
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, description: $description}';
  }
}
