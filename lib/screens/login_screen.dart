import 'package:flutter/material.dart';
import 'package:homework/routes/app_route.dart';
import 'package:homework/theme/app_colors.dart';
import 'package:homework/screens/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:homework/widgets/social_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPhoneSelected = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
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

  Future<void> _loginUser() async {
    // Re-validate just before submission to catch any missed updates
    _validatePassword();
    _validateEmailLive(_emailController.text);

    if (_emailError == null && _passwordError == null) {
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString('user_email');
      final storedPassword = prefs.getString('user_password');

      if (_emailController.text.trim() == storedEmail &&
          _passwordController.text.trim() == storedPassword) {
        // Successful login
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login successful! Welcome!')));
        // Navigate to the next screen (e.g., home screen)
        AppRouter.goToPhoneOtp(context); // Assuming you have a goToHome route
      } else {
        // Invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Show a snackbar if validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, body: _body);
  }

  Widget get _body {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _loginHeader,
              _formTextField,
              SizedBox(height: 12),
              _forgetPassword,
              SizedBox(height: 12),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Or with'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              SocialButtons(
                onGooglePressed: () => print('Google login'),
                onFacebookPressed: () => print('Facebook login'),
              ),
              const SizedBox(height: 32),
              _haveNoAccount,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _loginHeader {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Login',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 8),

        // Subtitle
        Text(
          'Please sign in to continue.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget get _forgetPassword {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // Handle forgot password tap
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            // optional for a link look
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

  Widget get _haveNoAccount {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Didn’t have account, ',
          children: [
            TextSpan(
              text: 'Register',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
