class Contact {
  int id;
  String name;
  String email;
  String phone;
  String? avatarUrl;

  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });
}
