import 'package:contatos_plus/app/view/contact_form.dart';
import 'package:contatos_plus/app/view/contact_list.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // ignore: constant_identifier_names
  static const HOME = '/';
  // ignore: constant_identifier_names
  static const CONTACT_FORM = 'contact-form';

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contato Plus App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routes: {
        HOME: (context) => ContactList(),
        CONTACT_FORM: (context) => ContactForm(),
      },
    );
  }
}
