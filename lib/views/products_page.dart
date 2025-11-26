import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../components/product_card.dart';
import '../routes/app_routes.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final produtos = provider.products;

    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco para ficar clean
      appBar: AppBar(
        title: const Text('Lojas e Restaurantes'), // Mudei o título para combinar
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
          : RefreshIndicator(
              onRefresh: _loadProducts,
              color: Colors.deepOrange,
              child: produtos.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('Nenhuma loja cadastrada.', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        // GridView faz os cards ficarem lado a lado e não esticados
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, // Largura máxima de cada loja
                          childAspectRatio: 0.75, // Proporção do cartão
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: produtos.length,
                        itemBuilder: (ctx, i) => ProductCard(produto: produtos[i]),
                      ),
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nova Loja", style: TextStyle(color: Colors.white)),
        onPressed: () => Navigator.pushNamed(context, AppRoutes.formProduto),
      ),
    );
  }
}