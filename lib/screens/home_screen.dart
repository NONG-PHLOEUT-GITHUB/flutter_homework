import 'package:flutter/material.dart';
import 'package:homework/theme/app_colors.dart';
import '../widgets/carousel_slider.dart';
// import 'package:homework/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedSport = "Football";

  final List<Map<String, dynamic>> sports = [
    {"name": "Football", "icon": Icons.sports_soccer, "color": Colors.green},
    {
      "name": "Basketball",
      "icon": Icons.sports_basketball,
      "color": Colors.orange,
    },
    {"name": "Tennis", "icon": Icons.sports_tennis, "color": Colors.yellow},
    {"name": "Cricket", "icon": Icons.sports_cricket, "color": Colors.blue},
    {"name": "Hockey", "icon": Icons.sports_hockey, "color": Colors.red},
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
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                // TODO: Handle notification action
              },
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
              children: const [
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ស្វែងរក...', // "Search..." in Khmer
                      border: InputBorder.none,
                    ),
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
          sectionHeader("បុរស"),
          SizedBox(height: 8),
          maleProductList,
          SizedBox(height: 16),
          sectionHeader("ស្រី"),
          SizedBox(height: 8),
          femaleProductList,
          SizedBox(height: 16)
        ],
      ),
    );
  }

  // 🔘 Category Chips
  final Widget categoryChips = Row(
    children: [
      categoryChip("ទាំងអស់", selected: true),
      categoryChip("បុរស"),
      categoryChip("ស្រី"),
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

  // 🧢 Male Product List
  final Widget maleProductList = SizedBox(
    height: 200,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        productCard('assets/images/image.webp', '\$17,00'),
        productCard('assets/images/image.webp', '\$32,00'),
        productCard('assets/images/image.webp', '\$21,00'),
      ],
    ),
  );

  // 👗 Female Product List
  final Widget femaleProductList = SizedBox(
    height: 200,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        productTagCard('assets/images/image.webp', '1780💙', 'New'),
        productTagCard('assets/images/image.webp', '1780💙', 'Sale'),
        productTagCard('assets/images/image.webp', '1780💙', 'Hot'),
        productTagCard('assets/images/image.webp', '1780💙', ''),
      ],
    ),
  );

  // 📦 Male Product Card
  static Widget productCard(String imgPath, String price) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgPath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 6),
          Text("Lorem ipsum dolor sit amet consectetur.", maxLines: 2),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 👒 Female Product Card with Tag
  static Widget productTagCard(String imgPath, String likes, String tag) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgPath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(likes, style: TextStyle(color: Colors.blue)),
              if (tag.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
            ],
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
            Text("ទាំងអស់", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_forward, color: Colors.blue),
          ],
        ),
      ],
    );
  }
}
