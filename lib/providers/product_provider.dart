import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  String _categoriaSelecionada = 'Todas';

  List<Product> get products {
    if (_categoriaSelecionada == 'Todas') return [..._products];
    return _products
        .where((p) => p.categoria == _categoriaSelecionada)
        .toList();
  }

  void filtrarPorCategoria(String categoria) {
    _categoriaSelecionada = categoria;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    try {
      final dados = await ApiService.get('products');
      _products = dados.map((item) => Product.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      print('Erro ao buscar produtos: $e');
    }
  }

  Future<void> addProduct(Product produto) async {
    try {
      await ApiService.post('products', produto.toJson());
      await fetchProducts(); // Recarrega a lista atualizada
    } catch (e) {
      print('Erro ao adicionar: $e');
    }
  }

  Future<void> updateProduct(Product produto) async {
    try {
      await ApiService.put('products', produto.id, produto.toJson());
      await fetchProducts();
    } catch (e) {
      print('Erro ao atualizar: $e');
    }
  }

  Future<void> removeProduct(String id) async {
    try {
      await ApiService.delete('products', id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao remover: $e');
    }
  }
}