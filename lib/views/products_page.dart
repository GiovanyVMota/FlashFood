import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../components/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _termoBusca = '';

  @override
  void initState() {
    super.initState();
    // Carrega os produtos ao iniciar a tela, caso ainda não tenham sido carregados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    
    // Lógica de filtro local
    final produtosFiltrados = _termoBusca.isEmpty
        ? provider.products
        : provider.products.where((p) =>
            p.nome.toLowerCase().contains(_termoBusca.toLowerCase()) ||
            p.categoria.toLowerCase().contains(_termoBusca.toLowerCase())
          ).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Explorar', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _termoBusca = v),
              decoration: InputDecoration(
                hintText: 'Buscar item ou loja...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: produtosFiltrados.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Nenhum produto encontrado.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: produtosFiltrados.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 Colunas
                childAspectRatio: 0.75, // Proporção do cartão
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (ctx, i) => ProductCard(produto: produtosFiltrados[i]),
            ),
    );
  }
}