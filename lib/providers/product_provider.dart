import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  // Busca produtos, opcionalmente filtrando por restaurante
  Future<void> fetchProducts([String? restaurantId]) async {
    try {
      String endpoint = 'products';
      if (restaurantId != null && restaurantId.isNotEmpty) {
        endpoint += '?restaurant_id=$restaurantId';
      }
      
      final dados = await ApiService.get(endpoint);
      _products = dados.map((item) => Product.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      print('Erro ao buscar produtos: $e');
    }
  }

  Future<void> addProduct(Product produto) async {
    try {
      await ApiService.post('products', produto.toJson());
      // Recarrega a lista do restaurante específico
      await fetchProducts(produto.restaurantId); 
    } catch (e) {
      print('Erro ao adicionar: $e');
      rethrow;
    }
  }

  // Método restaurado (Correção do erro)
  Future<void> updateProduct(Product produto) async {
    try {
      await ApiService.put('products', produto.id, produto.toJson());
      await fetchProducts(produto.restaurantId);
    } catch (e) {
      print('Erro ao atualizar: $e');
      rethrow;
    }
  }

  // Método restaurado (Correção do erro)
  Future<void> removeProduct(String id) async {
    try {
      await ApiService.delete('products', id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao remover: $e');
      rethrow;
    }
  }
}