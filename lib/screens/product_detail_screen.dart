import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  String _selectedSize = 'S';
  final List<String> _availableSizes = ['XS', 'S', 'M', 'L', 'XL'];

  void _incrementQuantity() {
    setState(() => _quantity++);
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() {
    Navigator.pop(context, {
      'product': widget.product,
      'quantity': _quantity,
      'size': _selectedSize,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1.2),
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCartBody(),
    );
  }

  Widget _buildCartBody() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Image.asset(
            widget.product.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),

        // Bottom Sheet Style Info Section
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Women's Medium Support",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Rating
                Row(
                  children: [
                    ...List.generate(
                      4,
                      (_) =>
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                    const Icon(
                      Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '(5.0)',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Text(
                  'Select size',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  children:
                      _availableSizes.map((size) {
                        final isSelected = size == _selectedSize;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = size),
                          child: Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFFFFD600)
                                      : Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                // Quantity and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Selector
                    Row(
                      children: [
                        _quantityButton(
                          icon: Icons.remove,
                          onPressed: _decrementQuantity,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _quantityButton(
                          icon: Icons.add,
                          onPressed: _incrementQuantity,
                        ),
                      ],
                    ),

                    // Static Price
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Add to Bag Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Add to Bag',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        width: 32,
        height: 32,
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }
}
