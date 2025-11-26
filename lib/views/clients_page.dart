import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/client_provider.dart';
import '../components/client_card.dart';
import '../routes/app_routes.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    await Provider.of<ClientProvider>(context, listen: false).fetchClients();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientProvider>(context);
    final clients = provider.clients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadClients,
              child: clients.isEmpty
                  ? const Center(child: Text('Nenhum cliente cadastrado.'))
                  : ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (ctx, i) =>
                          ClientCard(cliente: clients[i]),
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.formCliente),
        child: const Icon(Icons.add),
      ),
    );
  }
}
