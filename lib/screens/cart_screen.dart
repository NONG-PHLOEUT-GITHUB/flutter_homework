import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../theme/app_colors.dart';
import '../providers/cart_provider.dart'; // Import your CartProvider

class CartScreen extends StatefulWidget {
  final Function() onPlaceOrder;

  const CartScreen({Key? key, required this.onPlaceOrder}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16), // Optional spacing
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1.2),
              shape: BoxShape.circle,
              color:
                  Colors.white, // optional: match background or give contrast
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        title: const Text(
          'Shopping Bag',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _buildCartBody(cartProvider),
    );
  }

  Widget _buildCartBody(CartProvider cartProvider) {
    return Column(
      children: [
        Expanded(child: _buildCartList(cartProvider)),
        _buildCartSummary(cartProvider),
      ],
    );
  }

  Widget _buildCartList(CartProvider cartProvider) {
    if (cartProvider.items.isEmpty) {
      return const Center(
        child: Text(
          'Your shopping bag is empty.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartProvider.items.length,
      itemBuilder: (context, index) {
        final product = cartProvider.items.keys.elementAt(index);
        final quantity = cartProvider.items[product]!;

        return _buildCartItem(product, quantity, cartProvider);
      },
    );
  }

  Widget _buildCartItem(product, int quantity, CartProvider cartProvider) {
    return Dismissible(
      key: ObjectKey(product),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        cartProvider.removeProductFromCart(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} removed from cart.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              // Product Image and Details
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product.imagePath,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          product.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Price and Quantity Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      _qtyBtn(
                        Icons.remove,
                        () => cartProvider.updateCartItemQuantity(product, -1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _qtyBtn(
                        Icons.add,
                        () => cartProvider.updateCartItemQuantity(product, 1),
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
  }

  Widget _buildCartSummary(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 24, 16, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total items row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total items:', style: TextStyle(fontSize: 14)),
              Text(
                '${cartProvider.totalItems}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Colors.black12),

          // Total price row
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${cartProvider.cartTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  cartProvider.items.isEmpty
                      ? null
                      : () {
                        widget.onPlaceOrder();
                        Navigator.pop(context);
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }
}
