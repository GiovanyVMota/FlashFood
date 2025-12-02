import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class RestaurantProvider with ChangeNotifier {
  List<Restaurant> _restaurants = [];

  List<Restaurant> get restaurants => [..._restaurants];

  Future<void> fetchRestaurants() async {
    try {
      final dados = await ApiService.get('restaurants');
      _restaurants = dados.map((item) => Restaurant.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      print('Erro ao buscar restaurantes: $e');
    }
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      // O ApiService.post espera um Map<String, dynamic>
      await ApiService.post('restaurants', {
        'nome': restaurant.nome,
        'categoria': restaurant.categoria,
        'email': restaurant.emailProprietario,
        'imagemUrl': restaurant.imagemUrl,
      });
      await fetchRestaurants(); // Atualiza a lista local
    } catch (e) {
      print('Erro ao adicionar restaurante: $e');
      rethrow;
    }
  }
}