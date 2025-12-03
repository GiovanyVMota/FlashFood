import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/restaurante_provider.dart';
import 'home_page.dart';
import 'restaurants_page.dart'; // Importe a nova página

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Alterado: ProductsPage -> RestaurantsPage
  final List<Widget> _pages = const [
    HomePage(),
    RestaurantsPage(), 
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<RestaurantProvider>(context, listen: false).fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.deepOrange.withOpacity(0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined), 
            selectedIcon: Icon(Icons.home, color: Colors.deepOrange), 
            label: "Início"
          ),
          // Alterado: Ícone e Label para Restaurantes
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined), 
            selectedIcon: Icon(Icons.storefront, color: Colors.deepOrange), 
            label: "Restaurantes"
          ),
        ],
      ),
    );
  }
}