import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.4.1';
  
  // Send command to car
  Future<bool> sendCommand(String command) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/control'),
        body: {'command': command},
      ).timeout(const Duration(seconds: 2));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error sending command: $e');
      return false;
    }
  }

  // Set mode (AUTO or MANUAL)
  Future<bool> setMode(String mode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mode'),
        body: {'mode': mode},
      ).timeout(const Duration(seconds: 2));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error setting mode: $e');
      return false;
    }
  }

  // Get car status
  Future<Map<String, dynamic>?> getStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/status'),
      ).timeout(const Duration(seconds: 2));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'mode': data['mode'] ?? 'AUTO',
          'timeout': data['timeout'] ?? 0,
          'clients': data['clients'] ?? 0,
          'connected': true,
        };
      }
      return null;
    } catch (e) {
      print('Error getting status: $e');
      return null;
    }
  }
}
