import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = 'contacts';
final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String phoneColumn = 'phoneColumn';
final String emailColumn = 'emailColumn';
final String imgColumn = 'imgColumn';

final List<String> columns = [
  idColumn,
  nameColumn,
  phoneColumn,
  emailColumn,
  imgColumn
];

class Contact {
  int id;
  String name;
  String phone;
  String email;
  String img;

  Contact({this.id, this.name, this.phone, this.email, this.img});

  // Cria um objeto a partir de dados da table
  // passados no formato de mapa
  Contact.fromMap(Map tableMap) {
    id = tableMap[idColumn];
    name = tableMap[nameColumn];
    phone = tableMap[phoneColumn];
    email = tableMap[emailColumn];
    img = tableMap[imgColumn];
  }

  // Retorna um mapa para facilitar o insert
  // no banco
  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      nameColumn: name,
      phoneColumn: phone,
      emailColumn: email,
      imgColumn: img
    };
  }
}

class ContactProvider {
  Database _db;

  Future<Database> get dbContact async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final localPath = join(await getDatabasesPath(), 'contact.db');
    return await openDatabase(localPath, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE $tableName(
          $idColumn INTEGER PRIMARY KEY,
          $nameColumn TEXT,
          $phoneColumn TEXT,
          $emailColumn TEXT,
          $imgColumn TEXT
        )
      ''');
    }, version: 1);
  }

  void saveContact(Contact contact) async {
    Database db = await dbContact;
    db.insert('$tableName', contact.toMap());
  }

  Future<Contact> getContact(int id) async {
    Database db = await dbContact;
    List<Map> queryMap = await db.query(
      '$tableName',
      columns: columns,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
    if (queryMap.length > 0) {
      return Contact.fromMap(queryMap.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database db = await dbContact;
    return db.delete('$tableName', where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await dbContact;
    return await db.update('$tableName', contact.toMap(),
        where: '$idColumn = ?', whereArgs: [contact.id]);
  }

  Future<List<Contact>> getContacts() async {
    Database db = await dbContact;
    final List<Map<String, dynamic>> queryMaps =
        await db.rawQuery('SELECT * FROM $tableName');
    return List.generate(queryMaps.length, (index) {
      return Contact(
          id: queryMaps[index]['$idColumn'],
          name: queryMaps[index]['$nameColumn'],
          phone: queryMaps[index]['$phoneColumn'],
          email: queryMaps[index]['$emailColumn'],
          img: queryMaps[index]['$imgColumn']);
    });
  }

  Future close() async => dbContact.then((db) {
        db.close();
      });
}
