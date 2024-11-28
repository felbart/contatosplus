class ContactModel {
  String id;
  String nome;
  String telefone;
  String email;

  String urlAvatar;

  ContactModel({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.urlAvatar,
  });

  ContactModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nome = map['nome'],
        telefone = map['telefone'],
        email = map['email'],
        urlAvatar = map['urlAvatar'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'urlAvatar': urlAvatar,
    };
  }
}
