final createTable = '''
  CREATE TABLE contact (
  id INT PRIMARY KEY
  ,nome VARCHAR(200) NOT NULL
  ,telefone CHAR(16) NOT NULL
  ,email VARCHAR(150) NOT NULL
  ,url_avatar VARCHAR(300) NOT NULL
  )
''';

final insert1 = '''
  INSERT INTO contact(nome, telefone, email, url_avatar)
  VALUES('José Nunes','(62)9 9876-5432'','josenunes@exemplo.com','https://cdn.pixabay.com/photo/2021/05/10/14/15/corset-6243486_1280.jpg')
  ''';

final insert2 = '''
  INSERT INTO contact(nome, telefone, email, url_avatar)
  VALUES('Julia Lima','(62)9 9111-2345','julima@exemplo.com','https://cdn.pixabay.com/photo/2020/05/11/11/23/woman-5157666_1280.jpg')
  ''';

final insert3 = '''
  INSERT INTO contact(nome, telefone, email, url_avatar)
  VALUES('Tio Carlos','(62)9 93211-9879','ferreira.carlos@exemplo.com','https://cdn.pixabay.com/photo/2022/12/24/21/14/portrait-7676482_1280.jpg')
  ''';

final insert4 = '''
  INSERT INTO contact(nome, telefone, email, url_avatar)
  VALUES('Zé Filho','63)9 8400-1122','zefilho@exemplo.com','https://cdn.pixabay.com/photo/2016/11/20/09/13/aged-man-1842327_1280.jpg')
  ''';
