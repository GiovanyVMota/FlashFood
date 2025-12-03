class Product {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String categoria;
  final String imagemUrl;
  final String restaurantId;
  final String dataAtualizado; // Novo Campo

  Product({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoria,
    required this.imagemUrl,
    this.restaurantId = '',
    this.dataAtualizado = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      preco: double.tryParse(json['preco'].toString()) ?? 0.0,
      categoria: json['categoria'] ?? '',
      imagemUrl: json['imagemUrl'] ?? '',
      restaurantId: json['restaurant_id']?.toString() ?? '',
      // O banco envia datas no formato ISO ou string padrão
      dataAtualizado: json['data_atualizado']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'descricao': descricao,
    'preco': preco,
    'categoria': categoria,
    'imagemUrl': imagemUrl,
    'restaurant_id': restaurantId,
    // Não enviamos dataAtualizado pois o MySQL gerencia isso
  };
}