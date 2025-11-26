import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/client.dart';
import '../providers/client_provider.dart';

class FormCliente extends StatefulWidget {
  const FormCliente({super.key});

  @override
  State<FormCliente> createState() => _FormClienteState();
}

class _FormClienteState extends State<FormCliente> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _dados = {};

  void _loadFormData(Client? client) {
    if (client != null) {
      _dados['id'] = client.id;
      _dados['nome'] = client.nome;
      _dados['sobrenome'] = client.sobrenome;
      _dados['email'] = client.email;
      _dados['idade'] = client.idade.toString();
      _dados['foto'] = client.fotoUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final client = ModalRoute.of(context)!.settings.arguments as Client?;
    _loadFormData(client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final novoCliente = Client(
                  id: _dados['id'] ?? '',
                  nome: _dados['nome'],
                  sobrenome: _dados['sobrenome'],
                  email: _dados['email'],
                  idade: int.parse(_dados['idade']),
                  fotoUrl: _dados['foto'] ?? '',
                );

                final provider =
                    Provider.of<ClientProvider>(context, listen: false);

                if (_dados['id'] == null) {
                  provider.addClient(novoCliente);
                } else {
                  provider.updateClient(novoCliente);
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
                initialValue: _dados['sobrenome'],
                decoration: const InputDecoration(labelText: 'Sobrenome'),
                onSaved: (value) => _dados['sobrenome'] = value ?? '',
              ),
              TextFormField(
                initialValue: _dados['email'],
                decoration: const InputDecoration(labelText: 'E-mail'),
                onSaved: (value) => _dados['email'] = value ?? '',
                validator: (value) =>
                    value!.contains('@') ? null : 'E-mail inválido',
              ),
              TextFormField(
                initialValue: _dados['idade'],
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _dados['idade'] = value ?? '0',
              ),
              TextFormField(
                initialValue: _dados['foto'],
                decoration:
                    const InputDecoration(labelText: 'URL da foto (opcional)'),
                onSaved: (value) => _dados['foto'] = value ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
