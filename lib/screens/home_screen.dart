import 'package:flutter/material.dart';
import 'package:homework/theme/app_colors.dart';
import '../widgets/carousel_slider.dart';
import '../services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "ទាំងអស់";
  final TextEditingController _searchController = TextEditingController();
  String searchKeyword = "";

  final List<Map<String, dynamic>> allProducts = [
    {
      "image": 'assets/images/man_city.webp',
      "title": 'Mens Shirt',
      "currentPrice": '17.00',
      "oldPrice": '490.00',
      "category": 'បុរស',
    },
    {
      "image": 'assets/images/lp.jpg',
      "title": 'Ladies Top',
      "currentPrice": '32.00',
      "oldPrice": '490.00',
      "category": 'នារី',
    },
    {
      "image": 'assets/images/mc2.webp',
      "title": 'Kids Shirt',
      "currentPrice": '21.00',
      "oldPrice": '490.00',
      "category": 'ក្មេង',
    },
  ];

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
          const Text(
            'Hi, Nong',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Change to AppColors.onPrimary if defined
            ),
          ),
          // Notification icon with badge
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: IconButton(
              icon: Badge.count(
                count: 99,
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                ),
              ),
              // icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
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
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 8),
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
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// You can add more widgets like sliders or other cards here.
          ImageSlider(), //or any other content

          SizedBox(height: 12),
          categoryChips,
          SizedBox(height: 16),
          sectionHeader("New Arrivals"),
          SizedBox(height: 8),
          productList,
          SizedBox(height: 16),
        ],
      ),
    );
  }

  // 🔘 Category Chips
  final Widget categoryChips = Row(
    children: [
      categoryChip("ទាំងអស់", selected: true),
      categoryChip("បុរស"),
      categoryChip("នារី"),
      categoryChip("ក្មេង"),
    ],
  );

  static Widget categoryChip(String label, {bool selected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.red : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = allProducts;

    // Category filtering
    if (selectedCategory != "ទាំងអស់") {
      filtered =
          filtered
              .where(
                (p) =>
                    p['category'].toLowerCase() ==
                    selectedCategory.toLowerCase(),
              )
              .toList();
    }

    // Text filtering
    if (searchKeyword.isNotEmpty) {
      filtered =
          filtered
              .where((p) => p['title'].toLowerCase().contains(searchKeyword) || p['currentPrice'].toLowerCase().contains(searchKeyword))
              .toList();
    }

    return filtered;
  }

  Widget get productList {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            filteredProducts.map((product) {
              return productCard(
                product['image'],
                product['title'],
                product['currentPrice'],
                product['oldPrice'],
              );
            }).toList(),
      ),
    );
  }

  // 📦 Male Product Card
  static Widget productCard(
    String imgPath,
    String title,
    String currentPrice,
    String oldPrice,
  ) {
    return Container(
      width: 160,
      // height: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use fixed height for image section to avoid overflow
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imgPath,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite, color: Colors.red, size: 16),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$$currentPrice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '\$$oldPrice',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text("View all", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward, color: Colors.blue),
          ],
        ),
      ],
    );
  }
}
