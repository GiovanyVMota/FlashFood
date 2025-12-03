import 'package:flutter/material.dart';
import '../models/restaurante.dart';
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
      await ApiService.post('restaurants', restaurant.toJson());
      await fetchRestaurants();
    } catch (e) {
      print('Erro ao adicionar: $e');
      rethrow;
    }
  }

  Future<void> updateRestaurant(Restaurant restaurant) async {
    try {
      await ApiService.put('restaurants', restaurant.id, restaurant.toJson());
      await fetchRestaurants();
    } catch (e) {
      print('Erro ao atualizar: $e');
      rethrow;
    }
  }

  Future<void> removeRestaurant(String id) async {
    try {
      await ApiService.delete('restaurants', id);
      _restaurants.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao remover: $e');
      rethrow;
    }
  }
}