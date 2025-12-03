import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurante.dart';
import '../providers/restaurante_provider.dart';

class FormRestaurante extends StatefulWidget {
  const FormRestaurante({super.key});

  @override
  State<FormRestaurante> createState() => _FormRestauranteState();
}

class _FormRestauranteState extends State<FormRestaurante> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null && arg is Restaurant) {
        _formData['id'] = arg.id;
        _formData['nome'] = arg.nome;
        _formData['categoria'] = arg.categoria;
        _formData['email'] = arg.emailProprietario;
        _formData['imagemUrl'] = arg.imagemUrl;
      }
    }
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<RestaurantProvider>(context, listen: false);
      
      final restaurant = Restaurant(
        id: _formData['id'] as String? ?? '',
        nome: _formData['nome'] as String,
        categoria: _formData['categoria'] as String,
        emailProprietario: _formData['email'] as String,
        imagemUrl: _formData['imagemUrl'] as String? ?? 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=500', 
      );

      if (_formData['id'] == null) {
        await provider.addRestaurant(restaurant);
      } else {
        await provider.updateRestaurant(restaurant);
      }
      
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao salvar.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Ok'))],
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_formData['id'] == null ? 'Novo Restaurante' : 'Editar Restaurante')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['nome'] as String?,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      onSaved: (v) => _formData['nome'] = v ?? '',
                      validator: (v) => (v != null && v.length > 2) ? null : 'Nome inválido',
                    ),
                    TextFormField(
                      initialValue: _formData['categoria'] as String?,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      onSaved: (v) => _formData['categoria'] = v ?? '',
                    ),
                    TextFormField(
                      initialValue: _formData['email'] as String?,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      onSaved: (v) => _formData['email'] = v ?? '',
                    ),
                    TextFormField(
                      initialValue: _formData['imagemUrl'] as String?,
                      decoration: const InputDecoration(labelText: 'URL da Imagem'),
                      onSaved: (v) => _formData['imagemUrl'] = v ?? '',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}