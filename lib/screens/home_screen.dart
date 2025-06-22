import 'package:flutter/material.dart';
import 'package:homework/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/carousel_slider.dart';
import '../services/product_service.dart';
import '../models/product.dart'; // Import Product model
import '../models/category.dart'; // Import Category model
import '../services/category_service.dart'; // Import CategoryService
import '../services/order_service.dart'; // Import OrderService
import '../models/order.dart'; // Import Order model
import '../models/order_item.dart'; // Import OrderItem model
import '../database/database_helper.dart'; // Import DatabaseHelper for initial data/delete DB
import 'product_detail_screen.dart'; // Import the new ProductDetailScreen
import 'cart_screen.dart'; // Import the CartScreen

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

  Future<List<Product>>? _productsFuture; // Future to load products
  List<Product> _allProducts = []; // To hold all loaded products
  List<Product> _filteredProducts = []; // To hold filtered products for display

  // Cart management
  Map<Product, int> _cart = {}; // Product -> quantity
  double _cartTotal = 0.0;
  int _cartItemCount = 0; // To display badge count

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeData(); // Load data from DB on init
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_full_name') ?? '';
    setState(() {
      _fullName = name;
    });
  }

  // --- Database Initialization and Loading ---
  Future<void> _initializeData() async {
    // Uncomment the line below during development to reset the database
    // This is useful if you change your schema (e.g., added imagePath)
    // await _dbHelper.deleteDatabaseFile();
    // print("Database deleted on app start.");

    await _insertInitialData(); // Insert sample data if DB is empty
    _loadProducts(); // Load products after initial data is ensured
  }

  Future<void> _insertInitialData() async {
    // Check if categories exist, if not, insert them
    List<Category> existingCategories = await _categoryService.getCategories();
    if (existingCategories.isEmpty) {
      print('Inserting initial categories...');
      await _categoryService.insertCategory(Category(name: 'បុរស', description: 'Men\'s Apparel'));
      await _categoryService.insertCategory(Category(name: 'នារី', description: 'Women\'s Apparel'));
      await _categoryService.insertCategory(Category(name: 'ក្មេង', description: 'Kids\' Apparel'));
    }

    // Check if products exist, if not, insert them with image paths
    List<Product> existingProducts = await _productService.getProducts();
    if (existingProducts.isEmpty) {
      print('Inserting initial products...');
      // Assuming IDs 1, 2, 3 for 'បុរស', 'នារី', 'ក្មេង' categories respectively
      await _productService.insertProduct(Product(
          name: 'Mens Shirt',
          description: 'Stylish casual shirt for men.',
          price: 17.00,
          categoryId: 1, // 'បុរស'
          imagePath: 'assets/images/man_city.webp'
      ));
      await _productService.insertProduct(Product(
          name: 'Ladies Top',
          description: 'Comfortable and fashionable top for ladies.',
          price: 32.00,
          categoryId: 2, // 'នារី'
          imagePath: 'assets/images/lp.jpg'
      ));
      await _productService.insertProduct(Product(
          name: 'Kids Shirt',
          description: 'Fun and colorful shirt for kids.',
          price: 21.00,
          categoryId: 3, // 'ក្មេង'
          imagePath: 'assets/images/mc2.webp'
      ));
      await _productService.insertProduct(Product(
          name: 'Swoosh T-Shirt',
          description: 'Women\'s Medium Support',
          price: 95.00,
          categoryId: 2, // 'នារី'
          imagePath: 'assets/images/image_6ee93f.png' // Ensure this asset is in your pubspec.yaml
      ));
      await _productService.insertProduct(Product(
          name: 'Smart Watch',
          description: 'Fitness tracker with heart rate monitor.',
          price: 150.00,
          categoryId: 1, // 'បុរស' or 'នារី' depending on classification
          imagePath: 'assets/images/smart_watch.webp' // Placeholder, add your own asset
      ));
      await _productService.insertProduct(Product(
          name: 'Denim Jeans',
          description: 'Classic blue denim jeans, comfortable fit.',
          price: 45.00,
          categoryId: 1, // 'បុរស'
          imagePath: 'assets/images/denim_jeans.webp' // Placeholder, add your own asset
      ));
      await _productService.insertProduct(Product(
          name: 'Summer Dress',
          description: 'Light and airy dress for summer days.',
          price: 60.00,
          categoryId: 2, // 'នារី'
          imagePath: 'assets/images/summer_dress.webp' // Placeholder, add your own asset
      ));
      await _productService.insertProduct(Product(
          name: 'Toy Car',
          description: 'Colorful toy car for young children.',
          price: 10.50,
          categoryId: 3, // 'ក្មេង'
          imagePath: 'assets/images/toy_car.webp' // Placeholder, add your own asset
      ));
    }
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _productService.getProducts().then((products) {
        _allProducts = products;
        _applyFilters(); // Apply filters immediately after loading
        return products;
      });
    });
  }

  void _applyFilters() {
    List<Product> filtered = _allProducts;

    // Category filtering
    if (selectedCategory != "ទាំងអស់") {
      int? categoryIdToFilter;
      if (selectedCategory == 'បុរស') categoryIdToFilter = 1;
      else if (selectedCategory == 'នារី') categoryIdToFilter = 2;
      else if (selectedCategory == 'ក្មេង') categoryIdToFilter = 3;

      if (categoryIdToFilter != null) {
        filtered = filtered.where((p) => p.categoryId == categoryIdToFilter).toList();
      }
    }

    // Text filtering
    if (searchKeyword.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(searchKeyword) ||
              p.description.toLowerCase().contains(searchKeyword) ||
              p.price.toStringAsFixed(2).contains(searchKeyword))
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
  // --- End Database Initialization and Loading ---

  // --- Cart Operations ---
  void _addToCart(Product product, int quantity) {
    setState(() {
      // Create a new map to trigger a rebuild
      _cart = Map.from(_cart) // <--- CRITICAL LINE
        ..update(
          product,
          (currentQuantity) => currentQuantity + quantity,
          ifAbsent: () => quantity,
        );
      _cartTotal += product.price * quantity;
      _cartItemCount += quantity;
      print('HomeScreen: _addToCart - Cart state updated. New cart hash: ${_cart.hashCode}');
    });
    _showSnackBar('${product.name} x $quantity added to cart');
  }

  // Method to update cart item quantity (used by CartScreen)
  void _updateCartItemQuantity(Product product, int quantityChange) {
    setState(() {
      // Create a new map to trigger a rebuild
      Map<Product, int> newCart = Map.from(_cart); // <--- CRITICAL LINE

      if (newCart.containsKey(product)) {
        int currentQuantity = newCart[product]!;
        int newQuantity = currentQuantity + quantityChange;

        if (newQuantity > 0) {
          newCart[product] = newQuantity;
          _cartTotal += product.price * quantityChange;
          _cartItemCount += quantityChange;
        } else {
          // If new quantity is 0 or less, remove item
          _cartTotal -= product.price * currentQuantity; // Subtract original quantity value
          _cartItemCount -= currentQuantity;
          newCart.remove(product);
        }
      }
      _cart = newCart; // Assign the new map to _cart
      print('HomeScreen: _updateCartItemQuantity - Cart state updated. New cart hash: ${_cart.hashCode}');
    });
  }

  // Method to remove item from cart (used by CartScreen)
  void _removeProductFromCart(Product product) {
    setState(() {
      // Create a new map to trigger a rebuild
      Map<Product, int> newCart = Map.from(_cart); // <--- CRITICAL LINE

      if (newCart.containsKey(product)) {
        int quantity = newCart[product]!;
        newCart.remove(product);
        _cartTotal -= product.price * quantity;
        _cartItemCount -= quantity;
      }
      _cart = newCart; // Assign the new map to _cart
      print('HomeScreen: _removeProductFromCart - Cart state updated. New cart hash: ${_cart.hashCode}');
    });
  }

  Future<void> _placeOrder() async {
    if (_cart.isEmpty) {
      _showSnackBar('Cart is empty. Add some items first!', isError: true);
      return;
    }

    final newOrder = Order(
      totalAmount: _cartTotal,
      orderDate: DateTime.now().toIso8601String(),
    );

    List<OrderItem> orderItems = _cart.entries.map((entry) {
      return OrderItem(
        orderId: 0, // Temporary, will be updated by service
        productId: entry.key.id!,
        quantity: entry.value,
        price: entry.key.price,
      );
    }).toList();

    try {
      final orderId = await _orderService.createOrder(newOrder, orderItems);
      print('HomeScreen: Order placed with ID: $orderId');
      setState(() {
        _cart.clear(); // This already creates a new, empty map effectively
        _cartTotal = 0.0;
        _cartItemCount = 0;
      });
      _showSnackBar('Order placed successfully!');
      // You might want to refresh a list of past orders if you displayed them
    } catch (e) {
      print('HomeScreen: Error placing order: $e');
      _showSnackBar('Failed to place order: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.primary, // Use primary color for success
        duration: const Duration(seconds: 2),
      ),
    );
  }
  // --- End Cart Operations ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar,
      body: SingleChildScrollView(child: _body),
    );
  }

  PreferredSizeWidget get _appBar {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting
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
        // Cart Icon
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: IconButton(
            icon: Badge.count(
              count: _cartItemCount, // Use dynamic cart count
              isLabelVisible: _cartItemCount > 0,
              backgroundColor: Colors.red,
              child: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            ),
            onPressed: () async {
              // Navigate to CartScreen
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    cart: _cart,
                    cartTotal: _cartTotal,
                    onUpdateCartItem: _updateCartItemQuantity,
                    onRemoveCartItem: _removeProductFromCart,
                    onPlaceOrder: _placeOrder,
                  ),
                ),
              );
              // After returning from CartScreen, rebuild to reflect any changes
              setState(() {}); // This ensures HomeScreen rebuilds and updates its UI based on the new cart state
              print('HomeScreen: Returned from CartScreen. Rebuilding HomeScreen.');
            },
          ),
        ),
        const SizedBox(width: 10), // Spacing between icons
        // Database Reset Icon (Development Only)
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.black),
            onPressed: () async {
              await _dbHelper.deleteDatabaseFile();
              // Re-initialize data and refresh UI after deleting DB
              await _initializeData();
              _showSnackBar('Database reset and re-initialized!');
            },
            tooltip: 'Reset Database (Development Only)',
          ),
        ),
        const SizedBox(width: 10), // For spacing
      ],
    );
  }

  Widget get _body {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          /// Search Field
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
                      hintText: 'ស្វែងរក...', // "Search..." in Khmer
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchKeyword = value.toLowerCase();
                        _applyFilters(); // Apply filters on search change
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// You can add more widgets like sliders or other cards here.
          const ImageSlider(), //or any other content

          const SizedBox(height: 12),
          categoryChips,
          const SizedBox(height: 16),
          sectionHeader("New Arrivals"),
          const SizedBox(height: 8),
          productList, // Now uses FutureBuilder to load from DB
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // 🔘 Category Chips
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
    return SizedBox(
      height: 250, // Increased height to accommodate image and text
      child: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || _filteredProducts.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _productCard(product);
              },
            );
          }
        },
      ),
    );
  }

  // 📦 Product Card for Home Screen (now takes a Product object)
  Widget _productCard(Product product) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
        // If a product and quantity are returned, add to cart
        if (result != null && result is Map<String, dynamic>) {
          final addedProduct = result['product'] as Product;
          final addedQuantity = result['quantity'] as int;
          _addToCart(addedProduct, addedQuantity);
        }
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Hero(
                tag: 'productImage-${product.id}', // Hero tag for animation
                child: Image.asset(
                  product.imagePath,
                  height: 150, // Adjusted height for better display
                  width: double.infinity,
                  fit: BoxFit.cover, // Use cover for card preview
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      // Removed old price for simplicity as it's not in the Product model
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧾 Section Header with "See More"
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
            Text("View all", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, color: AppColors.primary),
          ],
        ),
      ],
    );
  }
}
