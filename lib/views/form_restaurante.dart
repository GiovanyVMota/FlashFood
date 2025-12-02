import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_provider.dart';

class FormRestaurante extends StatefulWidget {
  const FormRestaurante({super.key});

  @override
  State<FormRestaurante> createState() => _FormRestauranteState();
}

class _FormRestauranteState extends State<FormRestaurante> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<RestaurantProvider>(context, listen: false).addRestaurant(
        Restaurant(
          nome: _formData['nome'] as String,
          categoria: _formData['categoria'] as String,
          emailProprietario: _formData['email'] as String,
          // Imagem placeholder padrão se não tiver upload real ainda
          imagemUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=500&q=80', 
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Erro ao salvar o restaurante.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Ok'))
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Restaurante'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome do Restaurante'),
                      textInputAction: TextInputAction.next,
                      onSaved: (nome) => _formData['nome'] = nome ?? '',
                      validator: (val) => (val != null && val.length > 2) ? null : 'Nome muito curto',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Categoria (ex: Lanches, Pizza)'),
                      textInputAction: TextInputAction.next,
                      onSaved: (cat) => _formData['categoria'] = cat ?? '',
                      validator: (val) => (val != null && val.isNotEmpty) ? null : 'Informe a categoria',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'E-mail do Proprietário'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (email) => _formData['email'] = email ?? '',
                      validator: (val) => (val != null && val.contains('@')) ? null : 'E-mail inválido',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Salvar Restaurante', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}