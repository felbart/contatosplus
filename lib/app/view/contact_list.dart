import 'package:contatos_plus/app/my_app.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  final lista = [
    {
      id: 1,
      'nome': 'André Nunes',
      'telefone': '(62)9 9876-5432',
      'email': 'andrenunes@exemplo.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2021/05/10/14/15/corset-6243486_1280.jpg'
    },
    {
      id: 2,
      'nome': 'Julia Lima',
      'telefone': '(62)9 9111-2345',
      'email': 'julima@exemplo.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2020/05/11/11/23/woman-5157666_1280.jpg'
    },
    {
      id: 3,
      'nome': 'Carlos Ferreira',
      'telefone': '(62)9 93211-9879',
      'email': 'ferreira.carlos@exemplo.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2022/12/24/21/14/portrait-7676482_1280.jpg'
    },
    {
      id: 4,
      'nome': 'Zé Filho',
      'telefone': '(63)9 8400-1122',
      'email': 'zefilho@exemplo.com',
      'avatar':
          'https://cdn.pixabay.com/photo/2016/11/20/09/13/aged-man-1842327_1280.jpg'
    },
  ];

  static get id => null;

  @override
  Widget build(BuildContext context) {
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
        itemCount: lista.length,
        itemBuilder: (context, i) {
          dynamic contato = lista[i];
          dynamic avatar = CircleAvatar(
            backgroundImage: NetworkImage(contato['avatar']),
          );
          return ListTile(
            leading: avatar,
            title: Text(contato['nome']),
            subtitle: Text(contato['email']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(onPressed: null, icon: Icon(Icons.edit)),
                  IconButton(onPressed: null, icon: Icon(Icons.delete)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
