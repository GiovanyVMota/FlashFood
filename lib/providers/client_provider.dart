import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/api_service.dart';

class ClientProvider with ChangeNotifier {
  List<Client> _clients = [];

  List<Client> get clients => [..._clients];

  Future<void> fetchClients() async {
    try {
      final dados = await ApiService.get('clients');
      _clients = dados.map((item) => Client.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      print('Erro ao buscar clientes: $e');
    }
  }

  Future<void> addClient(Client client) async {
    try {
      await ApiService.post('clients', client.toJson());
      await fetchClients(); // Recarrega a lista do banco
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateClient(Client client) async {
    try {
      await ApiService.put('clients', client.id, client.toJson());
      await fetchClients();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeClient(String id) async {
    try {
      await ApiService.delete('clients', id);
      _clients.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}