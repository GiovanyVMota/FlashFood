import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'providers/client_provider.dart';
import 'providers/product_provider.dart';
import 'views/home_page.dart';
import 'views/clients_page.dart';
import 'views/main_navigation.dart';
import 'views/products_page.dart';
import 'views/form_cliente.dart';
import 'views/form_produto.dart';

void main() {
  // Removido: await Firebase.initializeApp();
  runApp(const FlashFoodApp());
}

class FlashFoodApp extends StatelessWidget {
  const FlashFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlashFood',
        theme: ThemeData(
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
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            bodyMedium: TextStyle(color: Colors.black87),
          ),
        ),
        routes: {
          AppRoutes.home: (ctx) => const MainNavigation(),
          AppRoutes.clients: (ctx) => const ClientsPage(),
          AppRoutes.products: (ctx) => const ProductsPage(),
          AppRoutes.formCliente: (ctx) => const FormCliente(),
          AppRoutes.formProduto: (ctx) => const FormProduto(),
        },
      ),
    );
  }
}