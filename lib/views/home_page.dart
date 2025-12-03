import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/auth_provider.dart'; // Garante que o AuthProvider seja encontrado
import '../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _tipoEntrega = 'Entrega em Casa';

  void _alternarEntrega() {
    setState(() {
      _tipoEntrega = _tipoEntrega == 'Entrega em Casa' 
          ? 'Retirada no Local' 
          : 'Entrega em Casa';
    });
  }

  void _abrirPerfil() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                auth.isAuth ? "Olá, ${auth.userName}" : "Perfil", 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 20),
              
              // Verifica se está logado para mostrar as opções certas
              if (!auth.isAuth) ...[
                ListTile(
                  leading: const Icon(Icons.login, color: Colors.deepOrange),
                  title: const Text("Fazer Login ou Cadastrar"),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).pushNamed(AppRoutes.login);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text("Meus Dados"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Sair da Conta", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    auth.logout();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Você saiu da conta.'))
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. CABEÇALHO ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _alternarEntrega,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tipoEntrega == 'Entrega em Casa' ? "Entregar em:" : "Retirar em:",
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            Row(
                              children: [
                                Text(
                                  _tipoEntrega == 'Entrega em Casa' ? "Casa" : "Loja",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange),
                                ),
                                const Icon(Icons.keyboard_arrow_down, color: Colors.deepOrange, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      onPressed: _abrirPerfil,
                    ),
                  ],
                ),
              ),

              // --- 2. BARRA DE BUSCA ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar em FlashFood...',
                    prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),

              // --- 3. BANNER PRINCIPAL ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    image: DecorationImage(
                      image: const NetworkImage(
                        'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?q=80&w=1470&auto=format&fit=crop',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.deepOrange.withOpacity(0.2), 
                        BlendMode.hardLight
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                      ),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    alignment: Alignment.bottomLeft,
                    child: const Text(
                      "Ofertas Imperdíveis!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // --- 4. SEÇÃO DE OFERTAS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Promoções do Dia 🔥",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text("Ver tudo")),
                  ],
                ),
              ),

              SizedBox(
                height: 220,
                child: Consumer<ProductProvider>(
                  builder: (ctx, provider, _) {
                    final products = provider.products;
                    // Pega até 5 produtos
                    final promoProducts = products.take(5).toList();

                    if (promoProducts.isEmpty) {
                      return const Center(child: Text("Carregando ofertas..."));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      itemCount: promoProducts.length,
                      itemBuilder: (ctx, i) {
                        final product = promoProducts[i];
                        return Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 15, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  product.imagemUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_,__,___) => Container(color: Colors.grey[200]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.nome,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.categoria,
                                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          "R\$ ${product.preco.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.green, 
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.local_offer, size: 14, color: Colors.deepOrange)
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Toque na aba 'Restaurantes' abaixo para ver todas as lojas.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}