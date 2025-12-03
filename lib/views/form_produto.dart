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
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        if (arg is Product) {
          // MODO EDIÇÃO: Recebemos um produto completo
          final product = arg;
          _formData['id'] = product.id;
          _formData['nome'] = product.nome;
          _formData['preco'] = product.preco;
          _formData['descricao'] = product.descricao;
          _formData['imagemUrl'] = product.imagemUrl;
          _formData['categoria'] = product.categoria;
          _formData['restaurantId'] = product.restaurantId;
          _imageUrlController.text = product.imagemUrl;
        } else if (arg is String) {
          // MODO CRIAÇÃO: Recebemos apenas o ID do restaurante
          _formData['restaurantId'] = arg;
          _formData['preco'] = 0.0; // Valor inicial seguro
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(_updateImage);
    _imageUrlFocus.dispose();
    _imageUrlController.dispose();
  }

  void _updateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      final novoProduto = Product(
        id: _formData['id'] as String? ?? '',
        nome: _formData['nome'] as String,
        descricao: _formData['descricao'] as String,
        preco: _formData['preco'] as double,
        imagemUrl: _formData['imagemUrl'] as String,
        categoria: _formData['categoria'] as String,
        // Garante que o restaurantId venha do formulário (fixo ou carregado)
        restaurantId: _formData['restaurantId'] as String? ?? '', 
      );

      if (_formData['id'] == null) {
        await provider.addProduct(novoProduto);
      } else {
        await provider.updateProduct(novoProduto);
      }

      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro ao salvar o produto.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
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
        title: Text(_formData['id'] == null ? 'Novo Produto' : 'Editar Produto'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['nome'] as String?,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
                      onSaved: (nome) => _formData['nome'] = nome ?? '',
                      validator: (name) {
                        final nome = name ?? '';
                        if (nome.trim().isEmpty) return 'Nome é obrigatório';
                        if (nome.trim().length < 3) return 'Nome precisa de no mínimo 3 letras';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['preco']?.toString(),
                      decoration: const InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocus),
                      onSaved: (price) => _formData['preco'] = double.tryParse(price ?? '') ?? 0.0,
                    ),
                    TextFormField(
                      initialValue: _formData['descricao'] as String?,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (desc) => _formData['descricao'] = desc ?? '',
                    ),
                    TextFormField(
                      initialValue: _formData['categoria'] as String?,
                      decoration: const InputDecoration(labelText: 'Categoria (ex: Lanches, Bebidas)'),
                      textInputAction: TextInputAction.next,
                      onSaved: (cat) => _formData['categoria'] = cat ?? '',
                    ),
                    // REMOVIDO: O campo visível de ID do Restaurante.
                    // O ID agora é gerido internamente via _formData['restaurantId']
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Url da Imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocus,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (url) => _formData['imagemUrl'] = url ?? '',
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Informe a URL')
                              : Image.network(_imageUrlController.text, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}