class Client {
  final String id;
  final String nome;
  final String sobrenome;
  final String email;
  final int idade;
  final String fotoUrl;

  Client({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.idade,
    required this.fotoUrl,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'].toString(),
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      email: json['email'],
      idade: json['idade'],
      fotoUrl: json['foto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'idade': idade,
        'foto': fotoUrl,
      };
}
