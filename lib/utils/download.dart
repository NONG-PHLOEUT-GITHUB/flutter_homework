import 'package:shared_preferences/shared_preferences.dart';

class TicketUtils {
  // Save a ticket
  static Future<void> saveTicket(String ticketId, String ticketDetails) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Store the ticket ID and details
    await prefs.setString('ticket_id', ticketId);
    await prefs.setString('ticket_details', ticketDetails);
  }

  // Get the saved ticket ID
  static Future<String?> getTicketId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('ticket_id');
  }

  // Get the saved ticket details
  static Future<String?> getTicketDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('ticket_details');
  }

  // Delete the saved ticket
  static Future<void> deleteTicket() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('ticket_id');
    await prefs.remove('ticket_details');
  }
}
