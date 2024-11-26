import 'package:contatos_plus/app/database/db_helper.dart';
import 'package:contatos_plus/app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactList extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _buscar() async {
    String path = join(await getDatabasesPath(), 'banco');
    Database db = await openDatabase(path, version: 1, onCreate: (db, v) {
      db.execute(createTable);
      db.execute(insert1);
      db.execute(insert2);
      db.execute(insert3);
      db.execute(insert4);
    });
    return db.query('contact');
  }

  static get id => null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _buscar(),
      builder: (context, futuro) {
        if (futuro.hasData) {
          var lista = futuro.data as List?;
          return Scaffold(
            appBar: AppBar(
              title: Text("Lista de contatos"),
              actions: [
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushNamed(MyApp.CONTACT_FORM);
                    }),
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
              itemCount: lista?.length ?? 0,
              itemBuilder: (context, i) {
                dynamic contato = lista[i];
                dynamic avatar = CircleAvatar(
                  backgroundImage: NetworkImage(contato['avatar']),
                );
                return ListTile(
                  leading: avatar,
                  dense: true,
                  title: Text(contato['nome']),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: null, icon: Icon(Icons.more_horiz)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
