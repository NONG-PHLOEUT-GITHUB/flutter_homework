import 'package:flutter/material.dart';
import 'package:homework/routes/app_route.dart';
import 'package:provider/provider.dart';
import 'package:homework/providers/cart_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(primary: Colors.green),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          dividerColor: Colors.green,
          headerBackgroundColor: Colors.green,
          headerForegroundColor: Colors.white,
        ),
      ),
      initialRoute: AppRouter.mainLayout,
      routes: AppRouter.routes,
    );
  }
}
