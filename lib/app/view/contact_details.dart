import 'package:contatos_plus/app/domain/contact.dart';
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
        title: const Text('Detalhes do Contato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                MyApp.CONTACT_FORM,
                arguments: contato,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(context, contato);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: 300,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (contato.urlAvatar.isNotEmpty)
                            ? NetworkImage(contato.urlAvatar)
                            : null,
                        child: (contato.urlAvatar.isEmpty)
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        contato.nome,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contato.telefone,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contato.email ?? 'Sem Email',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            MyApp.CONTACT_FORM,
                            arguments: contato,
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar Contato'),
                      ),
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
      builder: (context) => AlertDialog(
        title: const Text('Excluir Contato'),
        content: const Text('Tem certeza que deseja excluir este contato?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              // Adicione aqui a lógica para deletar o contato
              // Após a exclusão, volte para a lista de contatos
              Navigator.of(context).pop(); // Fechar o diálogo
              Navigator.of(context).pop(); // Voltar à tela de contatos
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
