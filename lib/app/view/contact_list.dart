import 'package:contatos_plus/app/domain/contact.dart';
import 'package:contatos_plus/app/domain/contact_dao.dart';
import 'package:contatos_plus/app/my_app.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  Future<List<Contact>> _buscar() async {
    return ContactDaoImpl().find();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: _buscar(),
      builder: (context, futuro) {
        if (futuro.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (futuro.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Erro ao carregar contatos: ${futuro.error}"),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger a rebuild
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const ContactList()),
                      );
                    },
                    child: const Text("Tentar novamente"),
                  ),
                ],
              ),
            ),
          );
        } else if (futuro.hasData && (futuro.data?.isEmpty ?? true)) {
          return const Scaffold(
            body: Center(child: Text("Nenhum contato encontrado.")),
          );
        }

        List<Contact> lista = futuro.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text("Lista de contatos"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(MyApp.CONTACT_FORM);
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Adicionar Contato',
            onPressed: () {
              Navigator.of(context).pushNamed(MyApp.CONTACT_FORM);
            },
            child: const Icon(Icons.add, size: 24),
          ),
          body: ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) => _buildContactTile(lista[i], context),
          ),
        );
      },
    );
  }

  Widget _buildContactTile(Contact contato, BuildContext context) {
    var avatar = (contato.urlAvatar.isNotEmpty)
        ? CircleAvatar(backgroundImage: NetworkImage(contato.urlAvatar))
        : const CircleAvatar(child: Icon(Icons.person));

    return ListTile(
      leading: avatar,
      title: Text(contato.nome),
      subtitle: Text(contato.telefone),
      onTap: () {
        Navigator.of(context).pushNamed(
          MyApp.CONTACT_DETAILS,
          arguments: contato,
        );
      },
    );
  }
}
