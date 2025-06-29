import 'package:flutter/material.dart';
import 'package:homework/providers/cart_provider.dart';
import 'package:homework/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/carousel_slider.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../database/database_helper.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'package:provider/provider.dart'; // Make sure this is imported

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "ទាំងអស់";
  final TextEditingController _searchController = TextEditingController();
  String searchKeyword = "";
  String _fullName = '';

  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final OrderService _orderService = OrderService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Product>>? _productsFuture;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  // --- REMOVE THESE LOCAL CART MANAGEMENT VARIABLES ---
  // Map<Product, int> _cart = {};
  // double _cartTotal = 0.0;
  // int _cartItemCount = 0;
  // --- END REMOVAL ---

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_full_name') ?? '';
    setState(() {
      _fullName = name;
    });
  }

  Future<void> _initializeData() async {
    await _insertInitialData();
    _loadProducts();
  }

  Future<void> _insertInitialData() async {
    List<Category> existingCategories = await _categoryService.getCategories();
    if (existingCategories.isEmpty) {
      await _categoryService.insertCategory(
        Category(name: 'បុរស', description: 'Men\'s Apparel'),
      );
      await _categoryService.insertCategory(
        Category(name: 'នារី', description: 'Women\'s Apparel'),
      );
      await _categoryService.insertCategory(
        Category(name: 'ក្មេង', description: 'Kids\' Apparel'),
      );
    }

    List<Product> existingProducts = await _productService.getProducts();
    if (existingProducts.isEmpty) {
      print('Inserting initial products...');
      await _productService.insertProduct(
        Product(
          name: 'Mens Shirt',
          description: 'Stylish casual shirt for men.',
          price: 17.00,
          categoryId: 1,
          imagePath: 'assets/images/man_city.webp',
        ),
      );
      await _productService.insertProduct(
        Product(
          name: 'Ladies Top',
          description: 'Comfortable and fashionable top for ladies.',
          price: 32.00,
          categoryId: 2,
          imagePath: 'assets/images/lp.jpg',
        ),
      );
      await _productService.insertProduct(
        Product(
          name: 'Kids Shirt',
          description: 'Fun and colorful shirt for kids.',
          price: 21.00,
          categoryId: 3,
          imagePath: 'assets/images/mc2.webp',
        ),
      );
      await _productService.insertProduct(
        Product(
          name: 'Swoosh T-Shirt',
          description: 'Women\'s Medium Support',
          price: 95.00,
          categoryId: 2,
          imagePath: 'assets/images/real.webp',
        ),
      );
      await _productService.insertProduct(
        Product(
          name: 'Smart Watch',
          description: 'Fitness tracker with heart rate monitor.',
          price: 150.00,
          categoryId: 1,
          imagePath: 'assets/images/real.webp',
        ),
      );
      await _productService.insertProduct(
        Product(
          name: 'Denim Jeans',
          description: 'Classic blue denim jeans, comfortable fit.',
          price: 45.00,
          categoryId: 1,
          imagePath: 'assets/images/real_2.webp',
        ),
      );
      await _productService.insertProduct(
        Product(
          name: 'Summer Dress',
          description: 'Light and airy dress for summer days.',
          price: 60.00,
          categoryId: 2,
          imagePath: 'assets/images/mc2.webp',
        ),
      );
      await _productService.insertProduct(
        Product(
          name: 'Toy Car',
          description: 'Colorful toy car for young children.',
          price: 10.50,
          categoryId: 3,
          imagePath: 'assets/images/man_city.webp',
        ),
      );
    }
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _productService.getProducts().then((products) {
        _allProducts = products;
        _applyFilters();
        return products;
      });
    });
  }

  void _applyFilters() {
    List<Product> filtered = _allProducts;

    if (selectedCategory != "ទាំងអស់") {
      int? categoryIdToFilter;
      if (selectedCategory == 'បុរស')
        categoryIdToFilter = 1;
      else if (selectedCategory == 'នារី')
        categoryIdToFilter = 2;
      else if (selectedCategory == 'ក្មេង')
        categoryIdToFilter = 3;

      if (categoryIdToFilter != null) {
        filtered =
            filtered.where((p) => p.categoryId == categoryIdToFilter).toList();
      }
    }

    if (searchKeyword.isNotEmpty) {
      filtered =
          filtered
              .where(
                (p) =>
                    p.name.toLowerCase().contains(searchKeyword) ||
                    p.description.toLowerCase().contains(searchKeyword) ||
                    p.price.toStringAsFixed(2).contains(searchKeyword),
              )
              .toList();
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _updateSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  // --- Cart Operations - REFACTOR TO USE PROVIDER ---
  // These methods will now directly call methods on CartProvider
  // The 'context' will automatically rebuild widgets listening to CartProvider.

  Future<void> _placeOrder() async {
    final cartProvider = context.read<CartProvider>();
    if (cartProvider.items.isEmpty) {
      _showSnackBar('Cart is empty. Add some items first!', isError: true);
      return;
    }

    final newOrder = Order(
      totalAmount: cartProvider.cartTotal,
      orderDate: DateTime.now().toIso8601String(),
    );

    List<OrderItem> orderItems =
        cartProvider.items.entries.map((entry) {
          return OrderItem(
            orderId: 0,
            productId: entry.key.id!,
            quantity: entry.value,
            price: entry.key.price,
          );
        }).toList();

    try {
      final orderId = await _orderService.createOrder(newOrder, orderItems);
      print('HomeScreen: Order placed with ID: $orderId');
      cartProvider.clearCart(); // Clear cart via provider
      _showSnackBar('Order placed successfully!');
    } catch (e) {
      print('HomeScreen: Error placing order: $e');
      _showSnackBar('Failed to place order: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  // --- End Cart Operations REFACTOR ---

  @override
  Widget build(BuildContext context) {
    // Watch CartProvider for changes to rebuild parts of UI that depend on it
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(cartProvider.itemCount), // Pass count from provider
      body: SingleChildScrollView(child: _body),
    );
  }

  PreferredSizeWidget _appBar(int cartItemCount) {
    // Now accepts cart count
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hi, ${_fullName.isNotEmpty ? _fullName : 'User'}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: IconButton(
            icon: Badge.count(
              count: cartItemCount, // Use dynamic cart count from parameter
              isLabelVisible: cartItemCount > 0,
              backgroundColor: Colors.red,
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              // Navigate to CartScreen
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CartScreen(
                        // NO LONGER PASSING CART DATA MANUALLY!
                        // CartScreen will also use Provider to access cart data.
                        onPlaceOrder:
                            _placeOrder, // Still need to pass this or refactor _placeOrder to be in CartScreen
                      ),
                ),
              );
              // No need for setState(() {}) here, Provider handles rebuilds
            },
          ),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.black),
            onPressed: () async {
              await _dbHelper.deleteDatabaseFile();
              await _initializeData();
              _showSnackBar('Database reset and re-initialized!');
            },
            tooltip: 'Reset Database (Development Only)',
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget get _body {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 220, 213, 213),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'ស្វែងរក...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchKeyword = value.toLowerCase();
                        _applyFilters();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const ImageSlider(),
          const SizedBox(height: 12),
          categoryChips,
          const SizedBox(height: 16),
          sectionHeader("New Arrivals"),
          const SizedBox(height: 8),
          productList,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget get categoryChips {
    return Row(
      children: [
        _categoryChip("ទាំងអស់", selectedCategory == "ទាំងអស់"),
        _categoryChip("បុរស", selectedCategory == "បុរស"),
        _categoryChip("នារី", selectedCategory == "នារី"),
        _categoryChip("ក្មេង", selectedCategory == "ក្មេង"),
      ],
    );
  }

  Widget _categoryChip(String label, bool selected) {
    return GestureDetector(
      onTap: () => _updateSelectedCategory(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget get productList {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || _filteredProducts.isEmpty) {
          return const Center(child: Text('No products found.'));
        } else {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
            children:
                _filteredProducts
                    .map((product) => _productCard(product))
                    .toList(),
          );
        }
      },
    );
  }

  Widget _productCard(Product product) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
        if (result != null && result is Map<String, dynamic>) {
          final addedProduct = result['product'] as Product;
          final addedQuantity = result['quantity'] as int;
          context.read<CartProvider>().addToCart(addedProduct, addedQuantity);
          _showSnackBar('${addedProduct.name} x $addedQuantity added to cart');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1, // Makes the image square
                child: Hero(
                  tag: 'productImage-${product.id}',
                  child: Image.asset(
                    product.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween, // Distributes space vertically
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CartProvider>().addToCart(product, 1);
                            _showSnackBar('${product.name} x 1 added to cart');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.all(4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 3,
                          ),
                          child: const Icon(Icons.add, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              "View all",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, color: AppColors.primary),
          ],
        ),
      ],
    );
  }
}
