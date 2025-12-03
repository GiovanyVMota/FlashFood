import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'providers/product_provider.dart';
import 'providers/restaurante_provider.dart';
import 'providers/auth_provider.dart'; // Importe o AuthProvider
import 'views/main_navigation.dart';
import 'views/restaurants_page.dart';
import 'views/restaurant_menu_page.dart';
import 'views/form_produto.dart';
import 'views/form_restaurante.dart';
import 'views/login_page.dart'; // Importe a Login Page

void main() {
  runApp(const FlashFoodApp());
}

class FlashFoodApp extends StatelessWidget {
  const FlashFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Adicionado Auth
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlashFood',
        theme: ThemeData(
          // ... (seu tema existente)
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            primary: Colors.deepOrange,
            secondary: Colors.orangeAccent,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            surfaceTintColor: Colors.white,
          ),
        ),
        routes: {
          AppRoutes.home: (ctx) => const MainNavigation(),
          AppRoutes.restaurants: (ctx) => const RestaurantsPage(),
          AppRoutes.restaurantMenu: (ctx) => const RestaurantMenuPage(),
          AppRoutes.formProduto: (ctx) => const FormProduto(),
          AppRoutes.formRestaurante: (ctx) => const FormRestaurante(),
          AppRoutes.login: (ctx) => const LoginPage(), // Rota registrada
        },
      ),
    );
  }
}