import 'dart:io';

import 'package:contatos_plus/app/domain/contact.dart';
import 'package:contatos_plus/app/domain/contact_dao.dart';
import 'package:contatos_plus/app/my_app.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Receber o contato via argumentos
    final Contact contato =
        ModalRoute.of(context)?.settings.arguments as Contact;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 24,
        ),
        title: const Text("Detalhes do Contato",
            style: TextStyle(
              fontSize: 20,
            )),
        // elevation: 2,
        // shadowColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              size: 20,
            ),
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                MyApp.CONTACT_FORM,
                arguments: contato,
              );
              if (result == true) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(true); // Atualiza a lista ao retornar
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 20,
              color: Colors.red,
            ),
            onPressed: () {
              _confirmDelete(context, contato);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.blueGrey.shade100,
            height: 1,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 60)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: 320,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 16,
                    bottom: 24,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (contato.urlAvatar.isNotEmpty)
                            ? (Uri.tryParse(contato.urlAvatar)?.isAbsolute ==
                                    true
                                ? NetworkImage(contato.urlAvatar)
                                : FileImage(File(contato.urlAvatar))
                                    as ImageProvider)
                            : null,
                        backgroundColor: (contato.urlAvatar.isEmpty)
                            ? Colors.blueAccent
                            : null,
                        child: (contato.urlAvatar.isEmpty)
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        contato.nome,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Informações do contato:",
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        contato.telefone,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        contato.email,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Divider(color: Colors.blueGrey.shade100),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Flexible(
                      //       child: FilledButton(
                      //         onPressed: null,
                      //         child: Text("Deletar"),
                      //       ),
                      //     ),
                      //     Flexible(
                      //       child: FilledButton(
                      //         onPressed: null,
                      //         child: Text("Editar"),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para confirmar exclusão
  void _confirmDelete(BuildContext context, Contact contato) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Contato"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/contato-deletado.png'),
              const SizedBox(height: 16),
              const Text("Tem certeza que deseja excluir este contato?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //fechar o dialog
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await ContactDaoImpl().remove(contato.id!);
                Navigator.of(context).pop(); //fechar o dialog
                Navigator.of(context).pop(true);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Contato deletado com sucesso!"),
                    duration: Duration(seconds: 2),
                  ),
                ); //voltar a tela anterior
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
  }
}
