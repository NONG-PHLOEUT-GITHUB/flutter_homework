// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart'; // Assuming you have AppColors defined

class CartScreen extends StatefulWidget {
  final Map<Product, int> cart;
  final double cartTotal;
  final Function(Product product, int quantity) onUpdateCartItem;
  final Function(Product product) onRemoveCartItem;
  final Function() onPlaceOrder;

  const CartScreen({
    Key? key,
    required this.cart,
    required this.cartTotal,
    required this.onUpdateCartItem,
    required this.onRemoveCartItem,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// 🧮 Dynamically calculate the current cart total
  double get cartTotal {
    return widget.cart.entries.fold(0.0, (total, entry) {
      final product = entry.key;
      final quantity = entry.value;
      return total + (product.price * quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
      'CartScreen: Building with cart hash: ${widget.cart.hashCode}, total: ${widget.cartTotal.toStringAsFixed(2)}',
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Shopping Bag',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                widget.cart.isEmpty
                    ? const Center(
                      child: Text(
                        'Your shopping bag is empty.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: widget.cart.length,
                      itemBuilder: (context, index) {
                        final product = widget.cart.keys.elementAt(index);
                        // Access quantity directly from widget.cart, which will be the updated map
                        final quantity = widget.cart[product]!;
                        print(
                          'CartScreen: Item ${product.name} rendering quantity: $quantity',
                        );

                        return Dismissible(
                          // Added Dismissible widget
                          key: ObjectKey(product), // Unique key for each item
                          direction:
                              DismissDirection
                                  .endToStart, // Swipe from right to left
                          onDismissed: (direction) {
                            // Call the remove item callback when dismissed
                            widget.onRemoveCartItem(product);
                            // No local setState needed here as Dismissible handles its own removal animation
                            // and parent rebuild will cause the item to disappear.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.name} removed from cart.',
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          background: Container(
                            // Background shown when swiping
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      product.imagePath,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${product.description}', // Or other details
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    // Quantity controls remain
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.orange,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              widget.onUpdateCartItem(
                                                product,
                                                -1,
                                              ); // Decrement quantity
                                              setState(
                                                () {},
                                              ); // NEW: Force CartScreen to rebuild to show new quantity
                                            },
                                          ),
                                          Text(
                                            '$quantity', // This should now update immediately
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              widget.onUpdateCartItem(
                                                product,
                                                1,
                                              ); // Increment quantity
                                              setState(
                                                () {},
                                              ); // NEW: Force CartScreen to rebuild to show new quantity
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          // Cart Summary and Checkout Button
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3), // Shadow above
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\$${widget.cartTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        widget.cart.isEmpty
                            ? null
                            : () {
                              widget.onPlaceOrder();
                              Navigator.pop(
                                context,
                              ); // Go back to Home Screen after placing order
                            },
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
