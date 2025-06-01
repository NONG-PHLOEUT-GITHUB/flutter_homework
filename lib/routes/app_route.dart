import 'package:flutter/material.dart';
import 'package:homework/screens/layout.dart';
import 'package:homework/screens/login_screen.dart';
import 'package:homework/screens/otp_comfirm_screen.dart';
import 'package:homework/screens/phone_OTP.dart';
import 'package:homework/screens/register_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String phoneOtp = '/phone-otp';
  static const String register = '/register';
  static const String mainLayout = '/layout';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    otp: (context) => const OtpVerificationPage(),
    phoneOtp: (context) => const PhoneOtpPage(),
    register: (_) => const RegisterScreen(),
    mainLayout: (context) => const MainLayout(),
  };

  // Corrected version of onGenerateRoute
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildRoute(const LoginPage());
      case otp:
        return _buildRoute(const OtpVerificationPage());
      case phoneOtp:
        return _buildRoute(const PhoneOtpPage());
      case register:
        return _buildRoute(const RegisterScreen());
      case mainLayout:
        return _buildRoute(const MainLayout());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  MaterialPageRoute _buildRoute(Widget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }


  // Optional: helper methods
  static void goToPhoneOtp(BuildContext context) {
    Navigator.pushNamed(context, phoneOtp);
  }

  static void goToOtp(BuildContext context) {
    Navigator.pushNamed(context, otp);
  }

  static void goToMainLayout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, mainLayout, (route) => false);
  }
}
