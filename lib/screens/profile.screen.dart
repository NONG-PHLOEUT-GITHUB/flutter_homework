import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _fullName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // You might also want to load dark mode preference here
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) { // Check if the widget is still mounted before calling setState
      setState(() {
        _fullName = prefs.getString('user_full_name') ?? 'No Name';
        _email = prefs.getString('user_email') ?? 'No Email';
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored preferences

    if (!mounted) return; // Ensure the widget is still in the tree

    // Replace '/login' with the actual route name of your login or welcome screen.
    // Make sure you have this route defined in your MaterialApp's routes.
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 16),
            _buildLanguageAndDarkModeRow(),
            SizedBox(height: 16),
            _buildSettingsOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            // Ensure this asset path is correct in your pubspec.yaml
            backgroundImage: AssetImage('assets/images/image.webp'),
            backgroundColor: Colors.grey[200], // Placeholder if image not found
            onBackgroundImageError: (exception, stackTrace) {
              // Handle image loading errors, e.g., show a default icon
              print('Error loading image: $exception');
            },
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _fullName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageAndDarkModeRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'English',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.edit,
            title: 'Edit Profile',
            onTap: () {
              print('Edit Profile tapped');
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
          ),
          _buildSettingsTile(
            icon: Icons.history,
            title: 'Order History',
            onTap: () {
              print('Order History tapped');
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
            },
          ),
          _buildSettingsTile(
            icon: Icons.location_on,
            title: 'Shipping Details',
            onTap: () {
              print('Shipping Details tapped');
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ShippingDetailsScreen()));
            },
          ),
          _buildSettingsTile(
            icon: Icons.card_giftcard,
            title: 'All Coupons',
            onTap: () {
              print('All Coupons tapped');
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => CouponsScreen()));
            },
          ),
          _buildSettingsTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
            },
          ),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            onTap: _logout, // Directly pass the _logout method
            isLast: true, // No bottom margin for the last item
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap, // This is the correct parameter type
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap, // Assign the provided onTap callback directly
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.black54),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}