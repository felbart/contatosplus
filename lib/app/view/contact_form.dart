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

  @override
  void initState() {
    super.initState();

    if (widget.contato != null) {
      _nomeController.text = widget.contato!.nome;
      _telefoneController.text = widget.contato!.telefone;
      _emailController.text = widget.contato!.email;
      _urlAvatar = File(widget.contato!.urlAvatar);
    }
  }

  void _salvarContato() async {
    final nome = _nomeController.text;
    final telefone = _telefoneController.text;
    final email = _emailController.text;
    final urlAvatar = _urlAvatar?.path ?? '';

    final contact = {
      'id': widget.contato?.id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'url_avatar': urlAvatar,
    };

    final dbHelper = DbHelper();

    if (widget.contato != null) {
      await dbHelper.updateContact(contact);
    } else {
      await dbHelper.insertContact(contact);
    }

    Navigator.of(context).pop(true);
    print('Contato salvo com sucesso');
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
        title: const Text("Novo Contato"),
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
