import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/client.dart';
import '../providers/client_provider.dart';
import '../routes/app_routes.dart';

class ClientCard extends StatelessWidget {
  final Client cliente;

  const ClientCard({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    final avatar = cliente.fotoUrl.isEmpty
        ? const CircleAvatar(child: Icon(Icons.person))
        : CircleAvatar(backgroundImage: NetworkImage(cliente.fotoUrl));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: avatar,
        title: Text('${cliente.nome} ${cliente.sobrenome}'),
        subtitle: Text(cliente.email),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.formCliente,
                  arguments: cliente,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Cliente'),
                      content: const Text('Deseja realmente excluir?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<ClientProvider>(context,
                                    listen: false)
                                .removeClient(cliente.id);
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Excluir'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
