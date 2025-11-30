import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../components/product_card.dart';
import '../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _tipoEntrega = 'Casa';
  String _termoBusca = '';

  // --- MAPA INTELIGENTE DE CATEGORIAS ---
  // Ensina o app quais restaurantes pertencem a qual categoria
  final Map<String, List<String>> _mapaCategorias = {
    'Marmita': ['Outback', 'Madero'], // Exemplo
    'Lanches': ['Burger King', 'McDonald\'s', 'Madero'],
    'Pizza': ['Pizza Hut', 'Domino\'s', 'Bráz Elettrica'],
    'Japonesa': ['Sushi House', 'Mori Ohta', 'Gendai'],
    'Doces': ['Cacau Show', 'Sodiê Doces', 'Bacio di Latte'],
    'Brasileira': ['Outback'],
  };

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    
    // LÓGICA DE FILTRO CORRIGIDA
    final produtos = _termoBusca.isEmpty
        ? productProvider.products
        : productProvider.products.where((p) {
            // 1. Verifica se o termo busca é uma Categoria conhecida (ex: clicou no botão "Pizza")
            if (_mapaCategorias.containsKey(_termoBusca)) {
              final restaurantesDessaCategoria = _mapaCategorias[_termoBusca]!;
              // Se a categoria do produto (que é o nome do restaurante) estiver na lista, mostra
              return restaurantesDessaCategoria.contains(p.categoria);
            }
            
            // 2. Se não for categoria, faz a busca normal por texto (Nome do prato ou Restaurante)
            return p.nome.toLowerCase().contains(_termoBusca.toLowerCase()) ||
                   p.categoria.toLowerCase().contains(_termoBusca.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.clients),
          ),
          const SizedBox(width: 16),
        ],
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _tipoEntrega,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.deepOrange, size: 20),
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
            onChanged: (String? newValue) => setState(() => _tipoEntrega = newValue!),
            items: <String>['Casa', 'Retirar', 'Trabalho'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Text(_tipoEntrega == value ? 'Entregar em ' : '', 
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey[600], fontSize: 12)),
                    Text(value),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => _termoBusca = value),
              decoration: InputDecoration(
                hintText: 'Buscar comida ou restaurante',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Só mostra categorias e banner se não estiver filtrando
            if (_termoBusca.isEmpty) ...[
              _buildCategorySection(context),
              _buildBannerSection(),
            ],

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _termoBusca.isEmpty ? 'Destaques' : 'Resultados para "$_termoBusca"',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_termoBusca.isEmpty)
                    Text('Ver mais', style: TextStyle(color: Colors.red[700], fontSize: 12)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: produtos.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40), 
                        child: Text("Nenhum item encontrado.", style: TextStyle(color: Colors.grey))
                      )
                    )
                  : GridView.builder(
                      shrinkWrap: true, 
                      physics: const NeverScrollableScrollPhysics(), 
                      itemCount: produtos.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (ctx, i) => ProductCard(produto: produtos[i]),
                    ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final categorias = [
      {'nome': 'Marmita', 'img': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=150&q=80'},
      {'nome': 'Lanches', 'img': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=150&q=80'},
      {'nome': 'Pizza', 'img': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=150&q=80'},
      {'nome': 'Japonesa', 'img': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=150&q=80'},
      {'nome': 'Doces', 'img': 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=150&q=80'},
    ];

    return Container(
      height: 110,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: categorias.length,
        itemBuilder: (ctx, index) {
          final cat = categorias[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () => setState(() => _termoBusca = cat['nome']!),
              child: Column(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(image: NetworkImage(cat['img']!), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(cat['nome']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerSection() {
    final banners = [
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80',
      'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600&q=80',
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: banners.length,
        itemBuilder: (ctx, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: NetworkImage(banners[index]), fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}