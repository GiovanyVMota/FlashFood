class Product {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String categoria;
  final String imagemUrl;
  final String dataAtualizado;

  Product({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoria,
    required this.imagemUrl,
    this.dataAtualizado = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      nome: json['nome'],
      descricao: json['descricao'],
      preco: double.tryParse(json['preco'].toString()) ?? 0.0,
      categoria: json['categoria'] ?? '',
      imagemUrl: json['imagemUrl'] ?? '',
      dataAtualizado: json['data_atualizado'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'preco': preco,
        'categoria': categoria,
        'imagemUrl': imagemUrl,
        // A data é gerada automaticamente pelo MySQL
      };
}