import 'package:flutter/material.dart';
import 'package:homework/l10n/l10n.dart';
import 'package:homework/routes/app_route.dart';
import 'screens/layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/otp_comfirm_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Static method for changing locale from anywhere
  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Default to English

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: L10n.all,
      // localizationsDelegates: const [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(primary: Colors.green),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          dividerColor: Colors.green,
          headerBackgroundColor: Colors.green,
          headerForegroundColor: Colors.white,
        ),
      ),
      initialRoute: AppRouter.login,
      routes: AppRouter.routes,
    );
  }
}
