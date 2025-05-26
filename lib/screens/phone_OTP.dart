import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homework/routes/app_route.dart';
import 'package:homework/theme/app_colors.dart';

class PhoneOtpPage extends StatelessWidget {
  const PhoneOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double paddingHorizontal = 24;
    final double borderRadius = 12;

    final TextStyle titleStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    final InputDecoration phoneInputDecoration = InputDecoration(
      hintText: '(855) 12 34 56 78',
      border: InputBorder.none,
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
              // Back button
              // Title
              Center(child: Text('Phone OTP', style: titleStyle)),

              const SizedBox(height: 48),

              // Phone Input Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: phoneInputDecoration,
                ),
              ),

              const SizedBox(height: 48),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    AppRouter.goToOtp(context);
                  },
                  style: buttonStyle,
                  child: const Text(
                    'Submit',
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
}
