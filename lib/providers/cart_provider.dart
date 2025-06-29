// providers/cart_provider.dart

import 'package:flutter/foundation.dart';
import 'package:homework/models/product.dart'; // Make sure your Product model is correctly imported

class CartProvider with ChangeNotifier {
  // This map stores the products and their quantities in the cart.
  // The 'Product' object itself acts as the key.
  final Map<Product, int> _items = {};

  // Getter to provide a read-only view of the cart items.
  Map<Product, int> get items => _items;

  // Getter to calculate the total number of items (sum of all quantities).
  int get itemCount => _items.values.fold(0, (sum, quantity) => sum + quantity);

  // Getter to calculate the total amount of all items in the cart.
  double get cartTotal {
    double total = 0.0;
    _items.forEach((product, quantity) {
      // Access product.price directly from the Product object key
      total += product.price * quantity;
    });
    return total;
  }

  // Method to add a product to the cart or increase its quantity.
  void addToCart(Product product, int quantity) {
    _items.update(
      product,
      (existingQuantity) => existingQuantity + quantity,
      ifAbsent: () => quantity,
    );
    notifyListeners(); // Notify widgets listening to this provider that data has changed
  }

  // Method to update the quantity of an existing item in the cart.
  void updateCartItemQuantity(Product product, int quantityChange) {
    if (_items.containsKey(product)) {
      int currentQuantity = _items[product]!;
      int newQuantity = currentQuantity + quantityChange;

      if (newQuantity > 0) {
        _items[product] = newQuantity;
      } else {
        _items.remove(product); // Remove if quantity drops to 0 or less
      }
      notifyListeners();
    }
  }

  // Method to remove a product entirely from the cart.
  void removeProductFromCart(Product product) {
    // Check if the product exists in the cart before attempting to remove it.
    // _items.remove(product) will return the quantity that was removed (an int), or null if not found.
    // We want to notify listeners ONLY if something was actually removed.
    if (_items.containsKey(product)) {
      // Check if the product key exists
      _items.remove(product); // Now safely remove it
      notifyListeners(); // Notify only if it was indeed present and removed
    }
  }

  int get totalItems => items.values.fold(0, (sum, quantity) => sum + quantity);

  // Method to clear all items from the cart.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
