import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class FormProduto extends StatefulWidget {
  const FormProduto({super.key});

  @override
  State<FormProduto> createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _dados = {};

  void _loadFormData(Product? produto) {
    if (produto != null) {
      _dados['id'] = produto.id;
      _dados['nome'] = produto.nome;
      _dados['descricao'] = produto.descricao;
      _dados['preco'] = produto.preco.toString();
      // Carregando os dados que faltavam
      _dados['categoria'] = produto.categoria;
      _dados['imagemUrl'] = produto.imagemUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is Product) {
      _loadFormData(args);
    } else if (args is Map) {
      _dados['categoria'] = args['categoriaPreenchida'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                
                final novoProduto = Product(
                  id: _dados['id'] ?? '',
                  nome: _dados['nome'],
                  descricao: _dados['descricao'],
                  preco: double.tryParse(_dados['preco']) ?? 0.0,
                  // Agora passando os parâmetros obrigatórios que faltavam
                  categoria: _dados['categoria'] ?? 'Outros',
                  imagemUrl: _dados['imagemUrl'] ?? '',
                  dataAtualizado: DateTime.now().toIso8601String(),
                );

                final provider =
                    Provider.of<ProductProvider>(context, listen: false);

                if (_dados['id'] == null || _dados['id'].toString().isEmpty) {
                  provider.addProduct(novoProduto);
                } else {
                  provider.updateProduct(novoProduto);
                }

                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _dados['nome'],
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _dados['nome'] = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                initialValue: _dados['descricao'],
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _dados['descricao'] = value ?? '',
              ),
              TextFormField(
                initialValue: _dados['preco'],
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => _dados['preco'] = value ?? '0',
              ),
              // Novo campo para Categoria
              TextFormField(
                initialValue: _dados['categoria'],
                decoration: const InputDecoration(labelText: 'Categoria (ex: Pizzas, Bebidas)'),
                onSaved: (value) => _dados['categoria'] = value ?? '',
              ),
              // Novo campo para URL da Imagem
              TextFormField(
                initialValue: _dados['imagemUrl'],
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
                onSaved: (value) => _dados['imagemUrl'] = value ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}