import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userName;

  bool get isAuth => _token != null;
  String get userName => _userName ?? 'Usuário';

  Future<void> _authenticate(String email, String password, String endpoint, [String? name]) async {
    try {
      final url = '${ApiService.baseUrl}/$endpoint';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': password,
          if (name != null) 'nome': name,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(responseData['message'] ?? 'Erro na autenticação');
      }

      _token = responseData['token'];
      _userId = responseData['id'].toString();
      _userName = responseData['nome'];
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    return _authenticate(email, password, 'register', name);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'login');
  }

  void logout() {
    _token = null;
    _userId = null;
    _userName = null;
    notifyListeners();
  }
}