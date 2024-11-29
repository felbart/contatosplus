import 'package:contatos_plus/app/database/connection.dart';
import 'package:contatos_plus/app/domain/contact.dart';
import 'package:sqflite/sqflite.dart';

abstract class ContactDAO {
  save(Contact contact);

  remove(int id);

  Future<List<Contact>> find();
}

class ContactDaoImpl implements ContactDAO {
  Database? _db;

  @override
  Future<List<Contact>> find() async {
    _db = await Connection.get();

    List<Map<String, Object?>>? resultado = await _db?.query('contact');

    if (resultado == null) {
      return [];
    }

    List<Contact> lista = List.generate(
      resultado.length,
      (i) {
        var linha = resultado[i];
        return Contact(
          id: linha['id'] as int,
          nome: linha['nome'] as String,
          telefone: linha['telefone'] as String,
          email: linha['email'] as String,
          urlAvatar: linha['url_avatar'] as String,
        );
      },
    );

    return lista;
  }

  @override
  remove(int id) async {
    _db = await Connection.get();
    var sql = 'DELETE FROM contact WHERE id=?';
    _db?.rawDelete(sql, [id]);
  }

  @override
  save(Contact contact) async {
    _db = await Connection.get();
    String sql;

    if (contact.id == null) {
      sql =
          'INSERT INTO contact (nome, telefone, email, url_avatar) VALUES (?,?,?,?)';
      _db?.rawInsert(sql, [
        contact.nome,
        contact.telefone,
        contact.email,
        contact.urlAvatar,
      ]);
    } else {
      sql =
          'UPDATE contact SET nome=?, telefone=?, email=?, url_avatar=? WHERE id=?';
      _db?.rawUpdate(sql, [
        contact.nome,
        contact.telefone,
        contact.email,
        contact.urlAvatar,
        contact.id,
      ]);
    }
  }
}
