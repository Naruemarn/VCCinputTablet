import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vccinputtablet/models/sqlite_model_server_setting.dart';

class SQLiteHeltper {
  final String databaseName = 'vccinput.db';
  final int version = 1;
  final String databaseTable = 'serverSetting';

  final String columnServer = 'server';
  final String columnUsername = 'username';
  final String columnPassword = 'password';
  final String columnDatabaseName = 'databaseName';
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  SQLiteHeltper() {
    initialDatabase();
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> initialDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) => db.execute('CREATE TABLE $databaseTable ($columnServer TEXT PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT, $columnDatabaseName TEXT)'),
      version: version,
    );
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Database> connectDatabase() async{
    return await openDatabase(join(await getDatabasesPath(), databaseName));
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<List<SQLiteModelServerSetting>> readSQLite_serverSetting() async {
  Database db = await connectDatabase();
  List<SQLiteModelServerSetting> results = [];
  List<Map<String, dynamic>> maps = await db.query(databaseTable);

  //print('maps on SQLiteHelper ==> $maps');

  for(var item in maps)
  {
    SQLiteModelServerSetting model = SQLiteModelServerSetting.fromMap(item);
    results.add(model);
  }

  return results;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<Null> insertValueToSQLite(SQLiteModelServerSetting data) async{
  Database db = await connectDatabase();
  await db.insert(databaseTable, data.toMap()).then((value) => print('Insert Value ${data.server} ${data.username} ${data.password} ${data.databaseName}'));
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<int?> getCount(String serverIP) async {
    Database db = await connectDatabase();
    var x = await db.rawQuery('SELECT COUNT (*) FROM $databaseTable WHERE $columnServer=?', [serverIP]);
    int? count = Sqflite.firstIntValue(x);
    return count;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<Null> updateValueToSQLite(SQLiteModelServerSetting data) async {
  Database db = await connectDatabase();
  await db.rawUpdate('UPDATE $databaseTable SET $columnUsername = ?, $columnPassword = ? , $columnDatabaseName = ? WHERE $columnServer = ?', [data.username, data.password, data.databaseName, data.server]).then((value) => print('Update Value ${data.server} ${data.username} ${data.password} ${data.databaseName}'));
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //ลบข้อมูลจากฐานข้อมูล
  Future<int> delete() async{
    print('Delete All row ServerSetting');
    Database db = await connectDatabase();
    return await db.delete(databaseTable);    
  }

}
