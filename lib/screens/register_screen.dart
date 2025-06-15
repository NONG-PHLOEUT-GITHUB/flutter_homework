import 'package:flutter/material.dart';
import 'package:homework/routes/app_route.dart';
import 'package:homework/screens/login_screen.dart';
import 'package:homework/services/file_service.dart';
import 'package:homework/theme/app_colors.dart';
import 'package:homework/widgets/social_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _fileService = FileService();

  String? _emailError;
  String? _fullNameError;
  String? _passwordError;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // _saveUserData();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _validateFullName(String value) {
    String fullName = _fullNameController.text;

    setState(() {
      if (fullName.isEmpty) {
        _fullNameError = 'Full name is required';
      } else {
        _fullNameError = null;
      }
    });
  }

  void _validatePassword() {
    String password = _passwordController.text;

    setState(() {
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (password.length < 8) {
        _passwordError = 'Password must be at least 8 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateEmailLive(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
        _emailError = 'Invalid email format';
      } else {
        _emailError = null;
      }
    });
  }

  void _submitForm() async {
    _validatePassword();
    _validateFullName(_fullNameController.text);
    _validateEmailLive(_emailController.text);

    if (_emailError == null && _passwordError == null) {
      final prefs = await SharedPreferences.getInstance();

      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await prefs.setString('user_full_name', fullName);
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password);
      // ⬇ Save to file
      await _fileService.saveEntry(fullName, email);
      // ignore: use_build_context_synchronously
      AppRouter.goToPhoneOtp(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _loginHeader,

              const SizedBox(height: 16),

              _formTextField,
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Divider with text
              Row(
                children: [
                  const Expanded(child: Divider()),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Or Sign up with',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              // Social Buttons
              const SizedBox(height: 24),

              SocialButtons(
                onGooglePressed: () => print('Google login'),
                onFacebookPressed: () => print('Facebook login'),
              ),

              const SizedBox(height: 28),
              _alreadyHaveAccount,

              // Register Now
            ],
          ),
        ),
      ),
    );
  }

  Widget get _formTextField {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),

        Text('Full name', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),

        TextField(
          decoration: InputDecoration(
            hintText: 'Enter your fulll name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            errorText: _fullNameError,
          ),
          controller: _fullNameController,
          onChanged: _validateFullName,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16),

        Text('Email', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),

        TextField(
          decoration: InputDecoration(
            hintText: 'Enter your email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            errorText: _emailError,
          ),
          controller: _emailController,
          onChanged: _validateEmailLive,
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: 16),

        Text('Password', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),

        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: (_) => _validatePassword(),
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            errorText: _passwordError,
            suffixIcon: GestureDetector(
              onTap: _togglePasswordVisibility,
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _alreadyHaveAccount {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an accoun ? "),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget get _loginHeader {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Register',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 8),

        // Subtitle
        Text(
          'Please register in to continue.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
