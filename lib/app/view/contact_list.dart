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
    return FutureBuilder(
      future: _buscar(),
      builder: (context, futuro) {
        if (futuro.hasData) {
          List<Contact> lista = futuro.data ?? [];
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
                var circleAvatar = CircleAvatar(
                    backgroundImage: NetworkImage(contato.urlAvatar));
                var avatar = circleAvatar;
                return ListTile(
                  leading: avatar,
                  title: Text(contato.nome),
                  subtitle: Text(contato.telefone),
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
