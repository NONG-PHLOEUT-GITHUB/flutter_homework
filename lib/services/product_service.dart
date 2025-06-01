import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadMaleProducts() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/products.json',
  );
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.cast<Map<String, dynamic>>();
}