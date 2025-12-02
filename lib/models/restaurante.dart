class Restaurant {
  final String id;
  final String nome;
  final String categoria;
  final String emailProprietario;
  final String imagemUrl;
  final double nota;

  Restaurant({
    this.id = '',
    required this.nome,
    required this.categoria,
    required this.emailProprietario,
    required this.imagemUrl,
    this.nota = 5.0,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'].toString(),
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? '',
      emailProprietario: json['email_proprietario'] ?? '',
      imagemUrl: json['imagemUrl'] ?? '',
      nota: double.tryParse(json['nota'].toString()) ?? 5.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'categoria': categoria,
    'email': emailProprietario,
    'imagemUrl': imagemUrl,
  };
}