import 'dart:convert';
import 'dart:io'; // Import necessário para Platform
import 'package:flutter/foundation.dart'; // Import para kIsWeb
import 'package:http/http.dart' as http;

class ApiService {
  // Ajusta a URL automaticamente dependendo da plataforma
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  static Future<List<dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode} ao buscar dados de $endpoint');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
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