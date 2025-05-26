import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatDate(String dateString, {String pattern = 'MMM dd, yyyy'}) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat(pattern).format(date);
    } catch (e) {
      return dateString; // fallback if parsing fails
    }
  }
}
