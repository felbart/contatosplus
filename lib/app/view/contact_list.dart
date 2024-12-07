import 'package:contatos_plus/app/domain/contact.dart';
import 'package:contatos_plus/app/domain/contact_dao.dart';
import 'package:contatos_plus/app/my_app.dart';
import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late Future<List<Contact>> _futureContacts;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      _futureContacts = ContactDaoImpl().find().then((contacts) {
        contacts.sort((a, b) => a.nome.compareTo(b.nome));
        return contacts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: _futureContacts,
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
                    onPressed: _loadContacts,
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

        final lista = futuro.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text("Lista de Contatos"),
            shadowColor: Colors.blueGrey.shade100,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final result =
                      await Navigator.of(context).pushNamed(MyApp.CONTACT_FORM);
                  if (result == true) {
                    _loadContacts();
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Adicionar Contato',
            backgroundColor: Colors.blueAccent,
            onPressed: () async {
              final result =
                  await Navigator.of(context).pushNamed(MyApp.CONTACT_FORM);
              if (result == true) {
                _loadContacts();
              }
            },
            child: const Icon(
              Icons.add,
              size: 24,
              color: Colors.white,
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(
              left: 16,
              top: 2,
              right: 16,
              bottom: 20,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: lista.length,
              itemBuilder: (context, i) => _buildContactTile(lista[i]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactTile(Contact contato) {
    final avatar = (contato.urlAvatar.isNotEmpty)
        ? CircleAvatar(backgroundImage: NetworkImage(contato.urlAvatar))
        : const CircleAvatar(child: Icon(Icons.person));

    return ListTile(
      leading: avatar,
      title: Text(contato.nome),
      subtitle: Text(contato.telefone),
      onTap: () async {
        final result = await Navigator.of(context).pushNamed(
          MyApp.CONTACT_DETAILS,
          arguments: contato,
        );
        if (result == true) {
          _loadContacts();
        }
      },
      trailing: IconButton(
        icon: const Icon(Icons.arrow_outward, color: Colors.blueGrey),
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed(
            MyApp.CONTACT_DETAILS,
            arguments: contato,
          );
          if (result == true) {
            _loadContacts();
          }
        },
      ),
    );
  }
}
