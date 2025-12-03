import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurante_provider.dart';
import '../routes/app_routes.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Restaurantes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.formRestaurante),
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (ctx, provider, child) {
          if (provider.restaurants.isEmpty) {
            return const Center(child: Text('Nenhum restaurante cadastrado.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: provider.restaurants.length,
            itemBuilder: (ctx, i) {
              final restaurant = provider.restaurants[i];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: restaurant.imagemUrl.isNotEmpty
                        ? NetworkImage(restaurant.imagemUrl)
                        : null,
                    child: restaurant.imagemUrl.isEmpty ? const Icon(Icons.store) : null,
                  ),
                  title: Text(restaurant.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(restaurant.categoria),
                  // Área de ações (Editar e Excluir)
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.formRestaurante,
                              arguments: restaurant,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Excluir?'),
                                content: const Text('Tem certeza que deseja remover este restaurante?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Não')),
                                  TextButton(
                                    onPressed: () {
                                      provider.removeRestaurant(restaurant.id);
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('Sim'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.restaurantMenu,
                      arguments: restaurant,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}