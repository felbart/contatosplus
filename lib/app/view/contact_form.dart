import 'dart:io';
import 'package:contatos_plus/app/domain/contact.dart';
import 'package:contatos_plus/app/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ContactForm extends StatefulWidget {
  final Contact? contato;

  const ContactForm({super.key, this.contato});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  File? _urlAvatar;

  final ImagePicker _picker = ImagePicker();

  late Contact _contact;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final contato = ModalRoute.of(context)?.settings.arguments as Contact?;

    if (contato != null) {
      _contact = contato;
      _nomeController.text = contato.nome;
      _telefoneController.text = contato.telefone;
      _emailController.text = contato.email;

      if (contato.urlAvatar.isNotEmpty) {
        _urlAvatar = File(contato.urlAvatar);
      }
    } else {
      _contact =
          Contact(id: null, nome: '', email: '', telefone: '', urlAvatar: '');
    }
  }

  void _salvarContato() async {
    final nome = _nomeController.text;
    final telefone = _telefoneController.text;
    final email = _emailController.text;
    final urlAvatar = _urlAvatar?.path ?? '';

    // Atualiza os dados no objeto _contact
    _contact.nome = nome;
    _contact.telefone = telefone;
    _contact.email = email;
    _contact.urlAvatar = urlAvatar;

    final dbHelper = DbHelper();

    if (_contact.id != null) {
      // Atualizar o contato existente
      await dbHelper.updateContact({
        'id': _contact.id,
        'nome': _contact.nome,
        'telefone': _contact.telefone,
        'email': _contact.email,
        'url_avatar': _contact.urlAvatar,
      });
      print('Contato atualizado com sucesso');
    } else {
      // Inserir um novo contato
      await dbHelper.insertContact({
        'nome': _contact.nome,
        'telefone': _contact.telefone,
        'email': _contact.email,
        'url_avatar': _contact.urlAvatar,
      });
      print('Novo contato inserido com sucesso');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contato salvo com sucesso!')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(37, 99, 235, 1),
        // titleTextStyle: TextStyle(
        //   color: Colors.white,
        //   fontSize: 24,
        // ),
        // iconTheme: IconThemeData(
        //   color: Colors.white,
        //   size: 24,
        // ),
        title: Text(_contact.id != null ? 'Editar Contato' : 'Novo Contato'),
        // elevation: 2,
        // shadowColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _salvarContato();
              }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Integrando o _formKey no widget Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _urlAvatar != null ? FileImage(_urlAvatar!) : null,
                    child: _urlAvatar == null
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O telefone é obrigatório.';
                  }
                  if (value.length < 14) {
                    return 'Insira um número de telefone válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O e-mail é obrigatório.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Insira um e-mail válido.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _urlAvatar = File(pickedFile.path);
      });
    }
  }
}
