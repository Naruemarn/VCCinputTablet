
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vccinputtablet/models/recipe_list_model.dart';
import 'package:vccinputtablet/models/sqlite_model_server_setting.dart';
import 'package:vccinputtablet/models/sqlite_model_vcc_castlog.dart';
import 'package:vccinputtablet/states/recipelist.dart';

class SQLiteHeltper {
  final String databaseName = 'vccinput.db';
  final int version = 1;
  final String tbl_serverSetting = 'serverSetting';
  final String tbl_vcc_castlog = 'vccCastLog';

  // Server Setting
  final String columnServer = 'server';
  final String columnUsername = 'username';
  final String columnPassword = 'password';
  final String columnDatabaseName = 'databaseName';

  // VCC CastLog
  String? column_timestamp = 'timestamp';
  String? column_machine_name = 'machine_name';
  String? column_serial = 'serial';
  String? column_recipe_name = 'recipe_name';

  String? column_job_id = 'job_id';
  String? column_design_code = 'design_code';
  String? column_alloy = 'alloy';
  String? column_flask_temp = 'flask_temp';
  String? column_weight = 'weight';

  String? column_wax = 'wax';
  String? column_wax_3d = 'wax_3d';
  String? column_resin = 'resin';

  String? column_mode1 = 'mode1';
  String? column_temp_setting_value = 'temp_setting_value';
  String? column_max_heat_power = 'max_heat_power';
  String? column_inert_gas = 'inert_gas';
  String? column_airwash = 'airwash';
  String? column_s_curve = 's_curve';
  String? column_acceleration = 'acceleration';
  String? column_rotation = 'rotation';
  String? column_pressure_pv = 'pressure_pv';
  String? column_rotation_time = 'rotation_time';
  String? column_exh_timing = 'exh_timing';

  String? column_mode2 = 'mode2';
  String? column_origin_point = 'origin_point';
  String? column_arm_origin_speed = 'arm_origin_speed';
  String? column_zero_point_adjust = 'zero_point_adjust';
  String? column_laser_light = 'laser_light';
  String? column_emissivity = 'emissivity';
  String? column_casting_keep_time = 'casting_keep_time';
  String? column_casting_range_degree = 'casting_range_degree';
  String? column_p = 'p';
  String? column_i = 'i';
  String? column_d = 'd';
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
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $tbl_serverSetting ($columnServer TEXT PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT, $columnDatabaseName TEXT)');
        await db.execute('CREATE TABLE $tbl_vcc_castlog ($column_timestamp TEXT, $column_machine_name TEXT, $column_serial TEXT, $column_recipe_name TEXT PRIMARY KEY, $column_job_id TEXT, $column_design_code TEXT, $column_alloy TEXT, $column_flask_temp TEXT, $column_weight TEXT, $column_wax TEXT, $column_wax_3d TEXT,  $column_resin TEXT,  $column_mode1 TEXT, $column_temp_setting_value TEXT, $column_max_heat_power TEXT, $column_inert_gas TEXT, $column_airwash TEXT, $column_s_curve TEXT,  $column_acceleration TEXT,  $column_rotation TEXT,  $column_pressure_pv TEXT,  $column_rotation_time TEXT, $column_exh_timing TEXT, $column_mode2 TEXT, $column_origin_point TEXT, $column_arm_origin_speed TEXT,  $column_zero_point_adjust TEXT, $column_laser_light TEXT, $column_emissivity TEXT, $column_casting_keep_time TEXT, $column_casting_range_degree TEXT, $column_p TEXT, $column_i TEXT, $column_d TEXT )');
      },
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
Future<List<SQLiteModelServerSetting>> readsqlite_serversetting() async {
  Database db = await connectDatabase();
  List<SQLiteModelServerSetting> results = [];
  List<Map<String, dynamic>> maps = await db.query(tbl_serverSetting);

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
Future<List<SQLiteModelVccCastLog>> readsqlite_vcc_castlog() async {
  Database db = await connectDatabase();
  List<SQLiteModelVccCastLog> results = [];
  List<Map<String, dynamic>> maps = await db.query(tbl_vcc_castlog);

  //print('maps on SQLiteHelper ==> $maps');

  for(var item in maps)
  {
    SQLiteModelVccCastLog model = SQLiteModelVccCastLog.fromMap(item);
    results.add(model);
  }

  return results;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<List<RecipeList_Model>> readsqliteVccCastLog_RecipeName() async {
    Database db = await connectDatabase();
    List<RecipeList_Model> results =  [];
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT timestamp, recipe_name FROM $tbl_vcc_castlog');

    print('maps on SQLiteHelper ==> $maps');
   
    for (var item in maps) {
      RecipeList_Model model = RecipeList_Model.fromMap(item);
      results.add(model);
    }
  return results;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<Null> insertValueToSQLite(SQLiteModelServerSetting data) async{
  Database db = await connectDatabase();
  await db.insert(tbl_serverSetting, data.toMap()).then((value) {
    print('Insert Value Server Config ==> ${data.server} ${data.username} ${data.password} ${data.databaseName}');
  });
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Future<Null> insertValueToSQLite_VccCastLog(SQLiteModelVccCastLog data) async{
  Database db = await connectDatabase();

  //await db.query('INSERT OR IGNORE INTO $tbl_vcc_castlog (timestamp, machine_name, serial, recipe_name, job_id, design_code, alloy, flask_temp, weight, wax, wax_3d, resin, mode1, temp_setting_value, max_heat_power, inert_gas, airwash, s_curve, acceleration, rotation, pressure_pv, rotation_time, exh_timing, mode2, origin_point, arm_origin_speed, zero_point_adjust, laser_light, emissivity, casting_keep_time, casting_range_degree, p, i, d) VALUES(${data.timestamp}, ${data.machine_name}, ${data.serial}, ${data.recipe_name}, ${data.job_id}, ${data.design_code}, ${data.alloy}, ${data.flask_temp}, ${data.weight}, ${data.wax}, ${data.wax_3d}, ${data.resin}, ${data.mode1}, ${data.temp_setting_value}, ${data.max_heat_power}, ${data.inert_gas}, ${data.airwash}, ${data.s_curve}, ${data.acceleration}, ${data.rotation}, ${data.pressure_pv}, ${data.rotation_time}, ${data.exh_timing}, ${data.mode2}, ${data.origin_point}, ${data.arm_origin_speed}, ${data.zero_point_adjust}, ${data.laser_light}, ${data.emissivity}, ${data.casting_keep_time}, ${data.casting_range_degree}, ${data.p}, ${data.i}, ${data.d}) UPDATE $tbl_vcc_castlog SET timestamp = ${data.timestamp}, machine_name = ${data.machine_name}, serial = ${data.serial}, recipe_name = ${data.recipe_name}, job_id = ${data.job_id}, design_code = ${data.design_code}, alloy = ${data.alloy}, flask_temp = ${data.flask_temp}, weight = ${data.weight}, wax = ${data.wax}, wax_3d = ${data.wax_3d}, resin = ${data.resin}, mode1 = ${data.mode1}, temp_setting_value = ${data.temp_setting_value}, max_heat_power = ${data.max_heat_power}, inert_gas = ${data.inert_gas}, airwash = ${data.airwash}, s_curve = ${data.s_curve}, acceleration = ${data.acceleration}, rotation = ${data.rotation}, pressure_pv = ${data.pressure_pv}, rotation_time = ${data.rotation_time}, exh_timing = ${data.exh_timing}, mode2 = ${data.mode2}, origin_point = ${data.origin_point}, arm_origin_speed = ${data.arm_origin_speed}, zero_point_adjust = ${data.zero_point_adjust}, laser_light = ${data.laser_light}, emissivity = ${data.emissivity}, casting_keep_time = ${data.casting_keep_time}, casting_range_degree = ${data.casting_range_degree}, p = ${data.p}, i = ${data.i}, d = ${data.d} WHERE recipe_name = ${data.recipe_name}');

  await db.insert(tbl_vcc_castlog, data.toMap()).then((value) {
    print('Insert Value VCC CastLog ==> ${data.timestamp} ${data.machine_name} ${data.serial} ${data.recipe_name}');
   });
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<int?> getCountVccCastLog(String recipe_name) async {
    Database db = await connectDatabase();
    //var x = await db.rawQuery('SELECT COUNT (*) FROM $databaseTable WHERE $columnServer=?', [serverIP]);
    var x = await db.rawQuery('SELECT COUNT (*) FROM $tbl_vcc_castlog WHERE recipe_name = ?', [recipe_name]);
    int? count = Sqflite.firstIntValue(x);
    return count;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<int?> getCount(String tbl_name) async {
    Database db = await connectDatabase();
    //var x = await db.rawQuery('SELECT COUNT (*) FROM $databaseTable WHERE $columnServer=?', [serverIP]);
    var x = await db.rawQuery('SELECT COUNT (*) FROM $tbl_name');
    int? count = Sqflite.firstIntValue(x);
    return count;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<Null> updateValueToSQLite(SQLiteModelServerSetting data) async {
  Database db = await connectDatabase();
  await db.rawUpdate('UPDATE $tbl_serverSetting SET $columnUsername = ?, $columnPassword = ? , $columnDatabaseName = ? WHERE $columnServer = ?', [data.username, data.password, data.databaseName, data.server]).then((value) => print('Update Value ${data.server} ${data.username} ${data.password} ${data.databaseName}'));
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future<Null> updateValueToSQLiteVccCastLog(SQLiteModelVccCastLog data) async {
  Database db = await connectDatabase();
  await db.rawUpdate('UPDATE $tbl_vcc_castlog SET timestamp = ?, machine_name = ?, serial = ?, recipe_name = ?, job_id = ?, design_code = ?, alloy = ?, flask_temp = ?, weight =  ?, wax =  ?, wax_3d =  ?, resin = ?, mode1 =  ?, temp_setting_value = ?, max_heat_power = ?, inert_gas = ?, airwash = ?, s_curve = ?, acceleration = ?, rotation = ?, pressure_pv = ?, rotation_time = ?, exh_timing = ?, mode2 = ?, origin_point = ?, arm_origin_speed = ?, zero_point_adjust = ?, laser_light = ?, emissivity = ?, casting_keep_time = ?, casting_range_degree = ?, p = ?, i = ?, d = ? WHERE recipe_name = ?', [data.timestamp, data.machine_name, data.serial, data.recipe_name, data.job_id, data.design_code, data.alloy, data.flask_temp, data.weight, data.wax, data.wax_3d, data.resin, data.mode1, data.temp_setting_value, data.max_heat_power, data.inert_gas, data.airwash, data.s_curve, data.acceleration, data.rotation, data.pressure_pv, data.rotation_time, data.exh_timing, data.mode2, data.origin_point, data.arm_origin_speed, data.zero_point_adjust, data.laser_light, data.emissivity, data.casting_keep_time, data.casting_range_degree, data.p, data.i, data.d, data.recipe_name]).then((value) {
    print('Update VCC CastLog Value ${data.recipe_name} ${data.machine_name} ${data.serial} ${data.job_id}');
  });
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  //ลบข้อมูลจากฐานข้อมูล
  Future<int> delete() async{
    print('Delete All row ServerSetting');
    Database db = await connectDatabase();
    return await db.delete(tbl_serverSetting);    
  }

}





