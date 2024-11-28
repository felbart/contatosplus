import 'package:contatos_plus/app/database/connection.dart';
import 'package:contatos_plus/app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  Future<List<Map<String, dynamic>>> _buscar() async {
    Database db = await Connection.get();
    return db.query('contact');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _buscar(),
      builder: (context, futuro) {
        if (futuro.hasData) {
          var lista = futuro.data ?? [];
          return Scaffold(
            appBar: AppBar(
              title: Text("Lista de contatos"),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
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
              itemBuilder: (context, i) {
                var contato = lista[i];
                var avatarUrl = contato['avatar'] as String?;
                var avatar = avatarUrl != null && avatarUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(contato['avatar']),
                      )
                    : const CircleAvatar(
                        child: Icon(Icons.person),
                      );
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contato['url_avatar'] != null
                        ? NetworkImage(contato['url_avatar'])
                        : null,
                    child: contato['url_avatar'] == null
                        ? Initicon(
                            text: "Nome completo",
                            elevation: 4,
                          )
                        : null,
                  ),
                  title: Text(contato['nome'] ?? 'Sem nome'),
                  subtitle: Text(contato['telefone'] ?? 'Sem telefone'),
                  onTap: () {
                    // print("Contato selecionado com ID: ${contato['id']}");
                  },
                );
              },
            ),
          );
        } else if (futuro.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Erro ao carregar contatos: ${futuro.error}"),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text("Nenhum contato encontrado.")),
          );
        }
      },
    );
  }
}
