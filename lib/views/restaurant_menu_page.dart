import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurante.dart';
import '../providers/product_provider.dart';
import '../routes/app_routes.dart';

class RestaurantMenuPage extends StatefulWidget {
  const RestaurantMenuPage({super.key});

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  Restaurant? _currentRestaurant;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    _currentRestaurant = restaurant;
    Provider.of<ProductProvider>(context, listen: false).fetchProducts(restaurant.id);
  }

  // Função para mostrar confirmação e excluir
  Future<void> _confirmDelete(BuildContext context, String productId) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tem certeza?'),
        content: const Text('Quer remover este item do cardápio?'),
        actions: [
          TextButton(
            child: const Text('Não'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Sim', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              try {
                // Chama o provider para remover
                await Provider.of<ProductProvider>(context, listen: false)
                    .removeProduct(productId);
                
                if (mounted) {
                  Navigator.of(ctx).pop(); // Fecha o diálogo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produto excluído com sucesso!')),
                  );
                }
              } catch (error) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao excluir produto.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = _currentRestaurant ?? Restaurant(nome: '', categoria: '', emailProprietario: '', imagemUrl: '');

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.formProduto,
                arguments: restaurant.id, 
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Cabeçalho do Restaurante
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepOrange.withOpacity(0.1),
            width: double.infinity,
            child: Column(
              children: [
                if (restaurant.imagemUrl.isNotEmpty)
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(restaurant.imagemUrl),
                  ),
                const SizedBox(height: 10),
                Text(
                  restaurant.categoria,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                const Text("⭐ 4.8 • 30-40 min • Grátis"),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Cardápio", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),

          // Lista de Produtos
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (ctx, productProvider, _) {
                final products = productProvider.products;

                if (products.isEmpty) {
                  return const Center(child: Text('Nenhum produto neste cardápio.'));
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (ctx, i) {
                    final product = products[i];
                    return ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(product.imagemUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(product.nome),
                      subtitle: Text(product.descricao, maxLines: 2, overflow: TextOverflow.ellipsis),
                      
                      // --- MUDANÇA AQUI: Adicionado botões de Ação ---
                      trailing: SizedBox(
                        width: 140, // Aumentei a largura para caber os botões
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Preço
                            Text(
                              'R\$ ${product.preco.toStringAsFixed(2)}', 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                            ),
                            
                            // Botão Editar
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.formProduto,
                                  arguments: product,
                                );
                              },
                            ),

                            // Botão Excluir (Novo)
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                              onPressed: () => _confirmDelete(context, product.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}