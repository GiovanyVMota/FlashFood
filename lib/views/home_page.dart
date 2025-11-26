import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../components/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _tipoEntrega = 'Casa'; // Estado para o Dropdown
  String _termoBusca = ''; // Estado para a busca

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // Lógica de filtro da busca
    final produtos = _termoBusca.isEmpty
        ? productProvider.products
        : productProvider.products
            .where((p) =>
                p.nome.toLowerCase().contains(_termoBusca.toLowerCase()) ||
                p.categoria.toLowerCase().contains(_termoBusca.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _tipoEntrega,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.deepOrange, size: 20),
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _tipoEntrega = newValue!;
              });
            },
            items: <String>['Casa', 'Retirar', 'Trabalho']
                .map<DropdownMenuItem<String>>((String value) {
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
              onChanged: (value) {
                setState(() {
                  _termoBusca = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar item ou loja',
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
            // Se não estiver buscando, mostra categorias e banners
            if (_termoBusca.isEmpty) ...[
              _buildCategorySection(context),
              _buildBannerSection(),
            ],

            // Título da Seção
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
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

            // Lista de Produtos em Grade (GridView)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: produtos.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Nenhum produto encontrado."),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true, // Importante para funcionar dentro de SingleChildScrollView
                      physics: const NeverScrollableScrollPhysics(), // Rola junto com a página
                      itemCount: produtos.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200, // Largura máxima de cada card
                        childAspectRatio: 0.75, // Proporção altura/largura (ajuste conforme necessário)
                        crossAxisSpacing: 16, // Espaço horizontal entre cards
                        mainAxisSpacing: 16, // Espaço vertical entre cards
                      ),
                      itemBuilder: (ctx, i) => ProductCard(produto: produtos[i]),
                    ),
            ),

            const SizedBox(height: 30),
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
      {'nome': 'Brasileira', 'img': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=150&q=80'},
      {'nome': 'Doces', 'img': 'https://images.unsplash.com/photo-1563729768-269148064852?w=150&q=80'},
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
              // Ao clicar na categoria, filtra a busca
              onTap: () {
                 setState(() {
                   _termoBusca = cat['nome']!;
                 });
              },
              child: Column(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(cat['img']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['nome']!,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
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
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80',
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
              image: DecorationImage(
                image: NetworkImage(banners[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}