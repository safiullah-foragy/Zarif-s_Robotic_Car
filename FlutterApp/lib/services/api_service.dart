import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.4.1';
  static const Duration timeout = Duration(seconds: 5);

  Future<bool> setMode(String mode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mode'),
        body: {'mode': mode},
      ).timeout(timeout);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendCommand(String command) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/control'),
        body: {'command': command},
      ).timeout(timeout);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/status'),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
