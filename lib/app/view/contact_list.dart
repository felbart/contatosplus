import 'dart:io';

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
          return Scaffold(
            appBar: AppBar(
              title: const Text("Lista de Contatos"),
              shadowColor: Colors.blueGrey.shade100,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final result = await Navigator.of(context)
                        .pushNamed(MyApp.CONTACT_FORM);
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Image.asset('assets/images/nenhum-contato.png'),
                Text(
                  "Você ainda não possui nenhum contato cadastrado.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                Text(
                  "Clique no botão abaixo para cadastrar um contato.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 16, color: Colors.blueGrey.shade400),
                ),
              ],
            ),
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
    // final randomColor =
    //     Colors.primaries[Random().nextInt(Colors.primaries.length)];

    final avatar = (contato.urlAvatar.isNotEmpty)
        ? (Uri.parse(contato.urlAvatar).isAbsolute == true
            ? CircleAvatar(
                backgroundImage: NetworkImage(contato.urlAvatar),
              )
            : CircleAvatar(
                backgroundImage: FileImage(File(contato.urlAvatar)),
              ))
        : CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.person, color: Colors.white),
          );

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
