import 'package:flutter/material.dart';
import 'restaurant_menu_page.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  // LISTA DE RESTAURANTES COM LINKS CORRIGIDOS (BANNERS E LOGOS)
  final List<Map<String, dynamic>> restaurantes = const [
    // --- PIZZAS ---
    {
      'nome': 'Pizza Hut',
      'categoria': 'Pizzas',
      'nota': 4.5,
      'tempo': '30-40 min',
      'taxa': 5.99,
      'banner': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Pizza_Hut_logo_%282014%29.svg/1024px-Pizza_Hut_logo_%282014%29.svg.png'
    },
    {
      'nome': 'Domino\'s',
      'categoria': 'Pizzas',
      'nota': 4.7,
      'tempo': '25-35 min',
      'taxa': 0.00,
      'banner': 'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Domino%27s_pizza_logo.svg/1200px-Domino%27s_pizza_logo.svg.png'
    },
    {
      'nome': 'Bráz Elettrica',
      'categoria': 'Pizzas',
      'nota': 4.9,
      'tempo': '40-50 min',
      'taxa': 8.00,
      'banner': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80',
      'logo': 'https://yt3.googleusercontent.com/ytc/AIdro_k39-fJ95KqOtbqQqTTA4XJt7_8yQ0XJ2H6Fw=s900-c-k-c0x00ffffff-no-rj' // Logo do YouTube do Bráz (Link estável)
    },

    // --- JAPONESA ---
    {
      'nome': 'Sushi House',
      'categoria': 'Japonesa',
      'nota': 4.8,
      'tempo': '40-50 min',
      'taxa': 7.50,
      'banner': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&q=80',
      'logo': 'https://cdn-icons-png.flaticon.com/512/2252/2252075.png' // Ícone de Sushi genérico e bonito
    },
    {
      'nome': 'Mori Ohta',
      'categoria': 'Japonesa',
      'nota': 4.9,
      'tempo': '50-60 min',
      'taxa': 8.00,
      'banner': 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=800&q=80',
      'logo': 'https://cdn-icons-png.flaticon.com/512/3183/3183423.png' // Outro ícone de sushi
    },
    {
      'nome': 'Gendai',
      'categoria': 'Japonesa',
      'nota': 4.4,
      'tempo': '30-40 min',
      'taxa': 4.90,
      'banner': 'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Gendai_logo.svg/1200px-Gendai_logo.svg.png'
    },

    // --- LANCHES ---
    {
      'nome': 'Burger King',
      'categoria': 'Lanches',
      'nota': 4.6,
      'tempo': '20-30 min',
      'taxa': 5.00,
      'banner': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Burger_King_logo_%281999%29.svg/2024px-Burger_King_logo_%281999%29.svg.png'
    },
    {
      'nome': 'McDonald\'s',
      'categoria': 'Lanches',
      'nota': 4.5,
      'tempo': '15-25 min',
      'taxa': 3.90,
      'banner': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/McDonald%27s_Golden_Arches.svg/2339px-McDonald%27s_Golden_Arches.svg.png'
    },
    {
      'nome': 'Madero',
      'categoria': 'Lanches',
      'nota': 4.8,
      'tempo': '35-45 min',
      'taxa': 8.00,
      'banner': 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Madero_Logo.svg/2560px-Madero_Logo.svg.png'
    },

    // --- DOCES ---
    {
      'nome': 'Cacau Show',
      'categoria': 'Doces',
      'nota': 4.9,
      'tempo': '10-20 min',
      'taxa': 2.00,
      'banner': 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Cacau_Show_logo.svg/2560px-Cacau_Show_logo.svg.png'
    },
    {
      'nome': 'Sodiê Doces',
      'categoria': 'Doces',
      'nota': 4.7,
      'tempo': '20-30 min',
      'taxa': 4.50,
      'banner': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Sodi%C3%AA_Doces_logo.svg/2560px-Sodi%C3%AA_Doces_logo.svg.png'
    },
    {
      'nome': 'Bacio di Latte',
      'categoria': 'Doces',
      'nota': 4.9,
      'tempo': '15-25 min',
      'taxa': 5.50,
      'banner': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800&q=80',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Bacio_di_Latte_logo.svg/2560px-Bacio_di_Latte_logo.svg.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Lojas e Restaurantes', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 1.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: restaurantes.length,
          itemBuilder: (ctx, i) => _buildRestaurantCard(context, restaurantes[i]),
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Map<String, dynamic> restaurante) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantMenuPage(restaurant: restaurante),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(restaurante['banner'] ?? ''),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          ),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3))
          ],
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    restaurante['nome'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${restaurante['categoria']} • ${restaurante['nota']} ⭐",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, shadows: [Shadow(color: Colors.black, blurRadius: 5)]),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                // Adicionei um padding pequeno para o logo não encostar na borda do círculo
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    restaurante['logo'],
                    fit: BoxFit.contain,
                    errorBuilder: (c,e,s) => const Icon(Icons.store, size: 20, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}