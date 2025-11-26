import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://localhost:3000'; 

  static Future<List<dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar dados de $endpoint');
    }
  }

  static Future<void> post(String endpoint, Map<String, dynamic> data) async {
    await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<void> put(String endpoint, String id, Map<String, dynamic> data) async {
    await http.put(
      Uri.parse('$baseUrl/$endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<void> delete(String endpoint, String id) async {
    await http.delete(Uri.parse('$baseUrl/$endpoint/$id'));
  }
}