import 'package:flutter/material.dart';
import 'package:homework/routes/app_route.dart';
import 'package:homework/theme/app_colors.dart';

class PhoneOtpPage extends StatefulWidget {
  const PhoneOtpPage({super.key});

  @override
  State<PhoneOtpPage> createState() => _PhoneOtpPageState();
}

class _PhoneOtpPageState extends State<PhoneOtpPage> {
  final TextEditingController _phoneController = TextEditingController();
  String? _phoneError;

  void _validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        _phoneError = 'Phone number is required';
      } else if (!RegExp(r'^(855|0)\d{8,11}$').hasMatch(value)) {
        _phoneError = 'Invalid phone number';
      } else {
        _phoneError = null;
      }
    });
  }

  void _submit() {
    _validatePhone(_phoneController.text);

    if (_phoneError == null) {
      AppRouter.goToOtp(context); // Navigate only if valid
    }
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHorizontal = 24;

    final InputDecoration phoneInputDecoration = InputDecoration(
      hintText: '(855) 12 34 56 78',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      errorText: _phoneError,
    );

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(elevation: 0, backgroundColor: AppColors.background),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _loginHeader,
              const SizedBox(height: 8),
              _subtitleText,
              const SizedBox(height: 48),
              Text(
                'Phone number',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: _validatePhone,
                decoration: phoneInputDecoration,
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: buttonStyle,
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget get _formTextField {

  // }

  final Widget _subtitleText = Text(
    'Enter your phone number to get OTP code',
    style: TextStyle(color: Colors.black54),
  );

  Widget get _loginHeader {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Phone OTP',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
