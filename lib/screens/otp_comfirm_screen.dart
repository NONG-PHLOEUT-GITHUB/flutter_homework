import 'package:flutter/material.dart';
import 'package:homework/routes/app_route.dart';
import 'package:pinput/pinput.dart';
import 'package:homework/theme/app_colors.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String _otpCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleText,
            const SizedBox(height: 8),
            _subtitleText,
            const SizedBox(height: 32),
            _otpField,
            const SizedBox(height: 32),
            _verifyButton,
            const Spacer(),
            _resendText,
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // AppBar
  final AppBar _appBar = AppBar(elevation: 0, backgroundColor: Colors.white);

  // Title Text
  final Widget _titleText = Text(
    'Verify OTP',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  );

  // Subtitle Text
  final Widget _subtitleText = Text(
    'Verify OTP',
    style: TextStyle(color: Colors.black54),
  );

  // OTP Field using Pinput (6-digit)
  Widget get _otpField {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      onChanged: (value) {
        setState(() {
          _otpCode = value;
        });
      },
      onCompleted: (code) {
        setState(() {
          _otpCode = code;
        });
      },
    );
  }

  // Verify Button
  Widget get _verifyButton {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Replace this with actual OTP verification
          if (_otpCode.length == 6) {
            AppRouter.goToMainLayout(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter 6-digit OTP')),
            );
          }
        },
        child: Text(
          'Send',
          style: TextStyle(fontSize: 16, color: AppColors.background),
        ),
      ),
    );
  }

  // Resend Text
  final Widget _resendText = Center(
    child: RichText(
      text: TextSpan(
        text: 'Didn’t receive code?  ', // e.g., "Didn’t receive code? "
        style: TextStyle(color: Colors.black54),
        children: [
          TextSpan(
            text: 'Resend',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
