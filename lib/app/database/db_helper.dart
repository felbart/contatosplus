final createTable = '''
  CREATE TABLE contact (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(200) NOT NULL,
    telefone CHAR(16) NOT NULL,
    email VARCHAR(150) NOT NULL,
    url_avatar VARCHAR(300)
  )
''';

final insert1 = '''
  INSERT INTO contact (nome, telefone, email, url_avatar)
  VALUES ('José Nunes', '(62) 9 9876-5432', 'josenunes@exemplo.com', 'https://img.freepik.com/psd-gratuitas/ilustracao-3d-de-uma-pessoa-com-oculos-de-sol_23-2149436188.jpg?uid=P1116948&ga=GA1.1.1436305783.1709082955&semt=ais_hybrid' )
''';

final insert2 = '''
  INSERT INTO contact (nome, telefone, email, url_avatar)
  VALUES ('Julia Lima', '(62) 9 9111-2345', 'julima@exemplo.com', 'https://cdn.pixabay.com/photo/2020/05/11/11/23/woman-5157666_1280.jpg')
''';

final insert3 = '''
  INSERT INTO contact (nome, telefone, email, url_avatar)
  VALUES ('Tio Carlos', '(62) 9 93211-9879', 'ferreira.carlos@exemplo.com', 'https://cdn.pixabay.com/photo/2022/12/24/21/14/portrait-7676482_1280.jpg')
''';

final insert4 = '''
  INSERT INTO contact (nome, telefone, email, url_avatar)
  VALUES ('Zé Filho', '(63) 9 8400-1122', 'zefilho@exemplo.com', 'https://cdn.pixabay.com/photo/2016/11/20/09/13/aged-man-1842327_1280.jpg')
''';
