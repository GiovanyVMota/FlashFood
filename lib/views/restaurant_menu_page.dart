import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../routes/app_routes.dart';
import '../models/product.dart';

class RestaurantMenuPage extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantMenuPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    
    final produtosDoRestaurante = provider.products
        .where((p) => p.categoria == restaurant['nome'])
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Banner (Limpo, sem nada em cima)
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.white, // Ícone de voltar branco
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    restaurant['banner'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                  ),
                  // Sombra suave apenas no topo para ver o botão de voltar
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Cabeçalho com Logo e Informações (ABAIXO do banner)
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alinha no topo
                    children: [
                      // LOGO (Quadrado arredondado ou Círculo, separado do banner)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                          image: DecorationImage(
                            image: NetworkImage(restaurant['logo'] ?? ''),
                            fit: BoxFit.contain, // Contain para não cortar o logo
                            // Se der erro, mostra ícone
                            onError: (e,s) {},
                          ),
                        ),
                        child: (restaurant['logo'] == null || restaurant['logo'].toString().isEmpty) 
                            ? const Icon(Icons.store, color: Colors.grey) 
                            : null,
                      ),
                      
                      const SizedBox(width: 16), // Espaço entre logo e texto
                      
                      // Texto e Avaliação
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['nome'] ?? 'Restaurante',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                Text(
                                  " ${restaurant['nota']} • ${restaurant['categoria']}",
                                  style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Link "Ver mais"
                      TextButton(
                        onPressed: () {}, 
                        child: const Text("Ver mais", style: TextStyle(color: Colors.red, fontSize: 12))
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Info de Entrega (Linha cinza)
                  Row(
                    children: [
                      _iconText(Icons.timer_outlined, restaurant['tempo'] ?? '30 min'),
                      const SizedBox(width: 20),
                      _iconText(
                        Icons.delivery_dining_outlined, 
                        (restaurant['taxa'] == null || restaurant['taxa'] == 0) ? "Grátis" : "R\$ ${restaurant['taxa'].toStringAsFixed(2)}"
                      ),
                      const Spacer(),
                      Text("Mínimo R\$ 10,00", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Barra de Busca
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar no cardápio",
                  prefixIcon: const Icon(Icons.search, color: Colors.red),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text("Destaques", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            ),
          ),

          // 4. Lista de Produtos (Visual de Lista Horizontal limpo)
          produtosDoRestaurante.isEmpty 
          ? const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text("Cardápio vazio.", style: TextStyle(color: Colors.grey))),
            )
          : SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildMenuItem(context, produtosDoRestaurante[index]),
                  childCount: produtosDoRestaurante.length,
                ),
              ),
            ),
            
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Adicionar", style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.pushNamed(
            context, 
            AppRoutes.formProduto,
            arguments: {'categoriaPreenchida': restaurant['nome']} 
          );
        },
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
    ]);
  }

  Widget _buildMenuItem(BuildContext context, Product produto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(produto.nome, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(produto.descricao, 
                  style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.3), 
                  maxLines: 2, overflow: TextOverflow.ellipsis
                ),
                const SizedBox(height: 8),
                Text("R\$ ${produto.preco.toStringAsFixed(2)}", 
                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 14)
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Imagem (Quadrada, fixa)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                produto.imagemUrl, 
                fit: BoxFit.cover,
                errorBuilder: (c,e,s) => Container(color: Colors.grey[100], child: const Icon(Icons.fastfood, color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}