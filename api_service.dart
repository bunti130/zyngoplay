import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Points to the live backend running in this workspace
  static const String baseUrl = 'https://ais-pre-y7krww7jnfjoojj2foffki-47089001332.asia-southeast1.run.app';
  static String? token;
  static String? userId;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userId = prefs.getString('userId');
  }

  static bool get isLoggedIn => token != null;

  static Future<bool> loginWithGoogle(String idToken, String deviceId, String fingerprint) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
          'deviceId': deviceId,
          'deviceFingerprint': fingerprint,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['sessionToken'];
        userId = data['uid'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token!);
        await prefs.setString('userId', userId!);
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false;
  }

  static Future<void> logout() async {
    token = null;
    userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
