import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:vccinputtablet/models/machine_model.dart';
import 'package:vccinputtablet/models/sqlite_model_server_setting.dart';
import 'package:vccinputtablet/models/sqlite_model_vcc_castlog.dart';
import 'package:vccinputtablet/states/recipelist.dart';
import 'package:vccinputtablet/states/setting_db.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:vccinputtablet/utility/my_constant.dart';
import 'package:vccinputtablet/utility/sqlite_helper.dart';
import 'package:vccinputtablet/widgets/show_progress.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Button
  //bool status_toggle = false;
  var isSelected1 = [true, false, false]; // Wax , Wax (3D), Resin
  var isSelected2 = [true, false]; // Manual , Auto
  var isSelected3 = [true, false, false]; // No, Argon, Nitrogen
  var isSelected4 = [true, false, false, false]; // No, 1times, 2times, 3times
  var isSelected5 = [true, false, false]; // Normal , Release, Keep
  var isSelected6 = [true, false]; // On , Off

  // Textbox
  final formkey = GlobalKey<FormState>();
  TextEditingController recipe_name = TextEditingController();
  TextEditingController job_id = TextEditingController();
  TextEditingController design_code = TextEditingController();
  TextEditingController alloy = TextEditingController();
  TextEditingController flask_temp = TextEditingController();
  TextEditingController weight_ = TextEditingController();

  TextEditingController temp_setting_value = TextEditingController();
  TextEditingController max_heat_power = TextEditingController();
  TextEditingController s_curve = TextEditingController();
  TextEditingController acceleration = TextEditingController();
  TextEditingController rotation = TextEditingController();
  TextEditingController pressure_pv = TextEditingController();
  TextEditingController rotation_time = TextEditingController();
  TextEditingController exh_timing = TextEditingController();

  TextEditingController origin_point = TextEditingController();
  TextEditingController arm_origin_speed = TextEditingController();
  TextEditingController zero_point_adjust = TextEditingController();
  TextEditingController emissivity = TextEditingController();
  TextEditingController casting_keep_time = TextEditingController();
  TextEditingController casting_range_degree = TextEditingController();
  TextEditingController p_ = TextEditingController();
  TextEditingController i_ = TextEditingController();
  TextEditingController d_ = TextEditingController();

  // Dropdown
  List<String> listMachineName = [];
  List<String> listSerial = [];
  String? selectedValue;

  // Database
  MachineModel? machineModel;

  List<SQLiteModelServerSetting> sqliteModels = [];
  List<SQLiteModelVccCastLog> recipe_list_model = [];

  bool load = true;
  int? cnt_server_config;
  String? server;
  String? username;
  String? password;
  String? databasename;

  // Variable
  String? _Timestamp = '2000-01-01 "00:00:00';
  String? _machineName = 'VCCxx';
  String? _serialNumber = 'S/N:';
  // String? _recipeName;

  // String? _jobId;
  // String? _designCode;
  // String? _alloy;
  // String? _flaskTemp;
  // String? _weight;

  String? _wax = '0';
  String? _wax3D = '0';
  String? _resin = '0';

  String? _mode1 = 'Manual';
  // String? _tempSettingValue;
  String? _inertGas = '0';
  String? _airWash = '0';
  // String? _sCurve;
  // String? _acceleration;
  // String? _rotation;
  // String? _pressurePV;
  // String? _rotationTime;
  // String? _exhTiming;

  String? _mode2 = 'Normal';
  // String? _originPoint;
  // String? _armOriginSpeed;
  // String? _zeroPointAdjust;
  String? _laserLight = 'On';
  // String? _emissivity;
  // String? _castingKeepTime;
  // String? _castingRangDegree;
  // String? _p;
  // String? _i;
  // String? _d;
  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> GET_DataSQLite(String recipe_name) async {
    await SQLiteHeltper()
        .readsqliteVccCastLog_RecipeList(recipe_name)
        .then((value) {
      print('Read Data SQLite WHERE Recipe Name : ${value}');
      setState(() {
        load = false;
        recipe_list_model = value;
      });
    });
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> process_count_row_ServerConfig() async {
    await SQLiteHeltper()
        .getCount(SQLiteHeltper().tbl_serverSetting)
        .then((value) async {
      //print('Count Row: $value');
      if (value! > 0) {
        processReadSQLite();
      } else {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingDB()))
            .then((value) => processReadSQLite());
      }

      setState(() {
        cnt_server_config = value;
      });
    });
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> processReadSQLite() async {
    await SQLiteHeltper().readsqlite_serversetting().then((value) async {
      print('value on processReadSQLite ===> $value');
      setState(() {
        load = false;
        sqliteModels = value;
        server = sqliteModels[0].server;
        username = sqliteModels[0].username;
        password = sqliteModels[0].password;
        databasename = sqliteModels[0].databaseName;
        print('Read Server Config: $server $username $password $databasename');
      });

      // Read From Server

      try {
        String api_get_machinename_sn =
            'http://$server/vcc_castlog/get_data.php?server=$server&user=$username&password=$password&db_name=$databasename';

        await Dio().get(api_get_machinename_sn).then((value) {
          print('Read M/C S/N: $value');

          listMachineName = [];
          for (var item in json.decode(value.data)) {
            setState(() {
              machineModel = MachineModel.fromMap(item);
              listMachineName.add(machineModel!.machine_name);
              listSerial.add(machineModel!.serial);
            });
          }
        });
      } on DioException catch (e) {
        popup_error('Cannot access server.\r\nPlease check the internet.');
      }
    });
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> processReadSQLite_VccCastLog() async {
    await SQLiteHeltper().readsqlite_vcc_castlog().then((value) {
      print('value on SQLite VCC CastLog ===> $value');
      setState(() {
        load = false;
      });
    });
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> processReadSQLite_VccCastLog_GET_RecipeName() async {
    await SQLiteHeltper().readsqliteVccCastLog_RecipeName();

    //print('Read Recipe Name SQLite : ${results}');
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> popup_error(String msg) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          //leading: ShowImage(path: MyConstant.confirm),
          leading: Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          title: Text(
            msg,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.normal, color: Colors.red),
          ),
          //subtitle: Text('Are you sure?', style: TextStyle(color: Colors.teal),),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> popup_information(String msg) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          //leading: ShowImage(path: MyConstant.confirm),
          leading: Icon(
            Icons.check,
            color: Colors.green,
            size: 50,
          ),
          title: Text(
            msg,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.blue),
          ),
          //subtitle: Text('Are you sure?', style: TextStyle(color: Colors.teal),),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> processInsertOrUpdateMySQL() async {
    final DateTime now = DateTime.now();
    _Timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    String sn = _serialNumber!.substring(4);
    try {
      String apiInsertData =
          'http://$server/vcc_castlog/insertData.php?server=$server&user=$username&password=$password&db_name=$databasename&timestamp=$_Timestamp&machine_name=$_machineName&serial=$sn&recipe_name=${recipe_name.text}&job_id=${job_id.text}&design_code=${design_code.text}&alloy=${alloy.text}&flask_temp=${flask_temp.text}&weight=${weight_.text}&wax=${_wax}&wax_3d=${_wax3D}&resin=${_resin}&mode1=${_mode1}&temp_setting_value=${temp_setting_value.text}&max_heat_power=${max_heat_power.text}&inert_gas=${_inertGas}&airwash=${_airWash}&s_curve=${s_curve.text}&acceleration=${acceleration.text}&rotation=${rotation.text}&pressure_pv=${pressure_pv.text}&rotation_time=${rotation_time.text}&exh_timing=${exh_timing.text}&mode2=${_mode2}&origin_point=${origin_point.text}&arm_origin_speed=${arm_origin_speed.text}&zero_point_adjust=${zero_point_adjust.text}&laser_light=${_laserLight}&emissivity=${emissivity.text}&casting_keep_time=${casting_keep_time.text}&casting_range_degree=${casting_range_degree.text}&p=${p_.text}&i=${i_.text}&d=${d_.text}';

      await Dio().get(apiInsertData).then((value) {
        popup_information('Uploading data...\r\nSuccess');
      });
    } on DioException catch (e) {
      popup_error('Cannot access server.\r\nPlease check the internet.');
    }
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> processInsertSQLite_VccCastLog() async {
    // Insert
    final DateTime now = DateTime.now();
    _Timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    String sn = _serialNumber!.substring(4);

    SQLiteModelVccCastLog data = SQLiteModelVccCastLog(
        timestamp: _Timestamp!,
        machine_name: _machineName!,
        serial: sn,
        recipe_name: recipe_name.text,
        job_id: job_id.text,
        design_code: design_code.text,
        alloy: alloy.text,
        flask_temp: flask_temp.text,
        weight: weight_.text,
        wax: _wax!,
        wax_3d: _wax3D!,
        resin: _resin!,
        mode1: _mode1!,
        temp_setting_value: temp_setting_value.text,
        max_heat_power: max_heat_power.text,
        inert_gas: _inertGas!,
        airwash: _airWash!,
        s_curve: s_curve.text,
        acceleration: acceleration.text,
        rotation: rotation.text,
        pressure_pv: pressure_pv.text,
        rotation_time: rotation_time.text,
        exh_timing: exh_timing.text,
        mode2: _mode2!,
        origin_point: origin_point.text,
        arm_origin_speed: arm_origin_speed.text,
        zero_point_adjust: zero_point_adjust.text,
        laser_light: _laserLight!,
        emissivity: emissivity.text,
        casting_keep_time: casting_keep_time.text,
        casting_range_degree: casting_range_degree.text,
        p: p_.text,
        i: i_.text,
        d: d_.text);

    await SQLiteHeltper().insertValueToSQLite_VccCastLog(data).then((value) {
      //Navigator.pop(context);
    });
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> processUpdateSQLite_VccCastLog() async {
    // Insert
    final DateTime now = DateTime.now();
    _Timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    String sn = _serialNumber!.substring(4);

    SQLiteModelVccCastLog data = SQLiteModelVccCastLog(
        timestamp: _Timestamp!,
        machine_name: _machineName!,
        serial: sn,
        recipe_name: recipe_name.text,
        job_id: job_id.text,
        design_code: design_code.text,
        alloy: alloy.text,
        flask_temp: flask_temp.text,
        weight: weight_.text,
        wax: _wax!,
        wax_3d: _wax3D!,
        resin: _resin!,
        mode1: _mode1!,
        temp_setting_value: temp_setting_value.text,
        max_heat_power: max_heat_power.text,
        inert_gas: _inertGas!,
        airwash: _airWash!,
        s_curve: s_curve.text,
        acceleration: acceleration.text,
        rotation: rotation.text,
        pressure_pv: pressure_pv.text,
        rotation_time: rotation_time.text,
        exh_timing: exh_timing.text,
        mode2: _mode2!,
        origin_point: origin_point.text,
        arm_origin_speed: arm_origin_speed.text,
        zero_point_adjust: zero_point_adjust.text,
        laser_light: _laserLight!,
        emissivity: emissivity.text,
        casting_keep_time: casting_keep_time.text,
        casting_range_degree: casting_range_degree.text,
        p: p_.text,
        i: i_.text,
        d: d_.text);

    await SQLiteHeltper().updateValueToSQLiteVccCastLog(data).then((value) {
      //Navigator.pop(context);
    });
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    process_count_row_ServerConfig();
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'VCC CASTLOG',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(10.0, 10.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              Shadow(
                offset: Offset(10.0, 10.0),
                blurRadius: 8.0,
                color: Color.fromARGB(125, 0, 0, 255),
              ),
            ],
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => InputForm()),
          //       );
          //     },
          //     icon: const Icon(
          //       Icons.keyboard_outlined,
          //       color: Colors.white,
          //       size: 25,
          //     )),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SettingDB()));
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25,
              )),
          IconButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 25,
              ))
        ],
      ),
      body: load
          ? ShowProgress()
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: formkey,
                child: ListView(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: [
                          build_selectMachine(context),
                          build_recipelistbutton(),
                          build_recipe_name(recipe_name),
                          build_uploadtbutton(),
                        ],
                      ),
                    ),
                    // SizedBox(height: 15),
                    //Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                build_serialnumber(),
                                build_wax_wax3d_resin(),
                              ],
                            ),
                            build_jobid(job_id),
                            build_design_code(design_code),
                            build_alloy(alloy),
                            build_flask_temp(flask_temp),
                            build_weight(weight_),
                            //buildTitle('* Use or No'),
                          ],
                        ),
                        Column(
                          children: [
                            build_image(),
                            build_recommend_to_fill(),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Divider(),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            buildTitle('Mode1', 6, 20),
                            build_manual_auto_button(),
                          ],
                        ),
                        Column(
                          children: [
                            buildTitle('Inert-Gas', 10, 20),
                            build_InertGas(),
                          ],
                        ),
                        Column(
                          children: [
                            buildTitle('Air-Wash', 10, 20),
                            build_airwash(),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        build_temp_setting(temp_setting_value),
                        build_max_heatpower(max_heat_power),
                        build_s_curve(s_curve),
                        build_acceleration(acceleration),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        build_rotation(rotation),
                        build_pressure_pv(pressure_pv),
                        build_rotation_time(rotation_time),
                        build_exh_timing(exh_timing),
                      ],
                    ),
                    // SizedBox(height: 15),
                    // Divider(),
                    Row(
                      children: [
                        Column(
                          children: [
                            buildTitle('Mode2', 6, 20),
                            build_normal_release_keep(),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        buildTitle_with_backgroundColor('GENERAL SETTING', 6, 0,
                            8, Color.fromARGB(255, 23, 207, 170), 252),
                        buildTitle_with_backgroundColor('PRESSURE SENSOR', 12,
                            0, 8, Color.fromARGB(95, 36, 106, 236), 120),
                      ],
                    ),
                    Row(
                      children: [
                        build_origin_point(origin_point),
                        build_arm_origin_speed(arm_origin_speed),
                        build_zero_point_adjust(zero_point_adjust),
                      ],
                    ),
                    buildTitle_with_backgroundColor('THERMO SENSOR', 6, 316, 8,
                        Color.fromARGB(255, 73, 158, 238), 252),
                    Row(
                      children: [
                        //buildTitle('Laser light:', 6, 0),
                        //build_toggle_switch_laser_light(),
                        build_laserlight_onoff(),
                        build_emissivity(emissivity),
                      ],
                    ),
                    // SizedBox(height: 10),
                    // Divider(),
                    buildTitle_with_backgroundColor_tempcontroller(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        build_casting_keep_time(casting_keep_time),
                        build_casting_range_degree(casting_range_degree),
                        build_p(p_),
                        build_i(i_),
                        build_d(d_),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /*Container build_toggle_switch_laser_light() {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6, top: 1),
      height: 30,
      width: 60,
      //color: Colors.pink,
      child: FlutterSwitch(
        width: 60.0,
        height: 30.0,
        activeColor: Colors.lightGreen,
        activeText: 'ON',
        inactiveText: 'OFF',
        activeTextColor: Colors.black,
        inactiveTextColor: Colors.black,
        valueFontSize: 10.0,
        toggleSize: 20.0,
        value: status_toggle,
        borderRadius: 30.0,
        padding: 4.0,
        showOnOff: true,
        onToggle: (val) {
          setState(() {
            status_toggle = val;
            print('Thermo sensor: $status_toggle');
          });
        },
      ),
    );
  }*/

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_image() {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      //color: MyConstant.dark,
      height: 220,
      width: 340,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: MyConstant.dark, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            MyConstant.image1,
            width: 345.0,
          ),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_wax_wax3d_resin() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      //width: 170,
      //color: Colors.pink,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ToggleButtons(
          //constraints: BoxConstraints.expand(height: 30, width: 54),
          fillColor: Colors.lightGreen,
          selectedColor: Colors.purple,
          borderColor: Colors.blueGrey,
          borderWidth: 2,
          selectedBorderColor: Colors.blue,
          splashColor: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          children: [
            Text('Wax',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Wax (3D)',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Resin',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
          onPressed: (int index) {
            setState(() {
              isSelected1[index] = !isSelected1[index];
              print("Wax Wax3D Resin : ${isSelected1}");

              if (isSelected1[0]) {
                _wax = '1';
              } else {
                _wax = '0';
              }

              if (isSelected1[1]) {
                _wax3D = '1';
              } else {
                _wax3D = '0';
              }

              if (isSelected1[2]) {
                _resin = '1';
              } else {
                _resin = '0';
              }

              print('Wax Wax3D Resin ===========> $_wax $_wax3D $_resin');
            });
          },
          isSelected: isSelected1,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_laserlight_onoff() {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 2, top: 5),
      height: 30,
      //color: Colors.pink,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ToggleButtons(
          fillColor: Colors.lightGreen,
          selectedColor: Colors.purple,
          borderColor: Colors.blueGrey,
          borderWidth: 2,
          selectedBorderColor: Colors.blue,
          splashColor: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          children: [
            Text('Laser light\r\nOn',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Laser light\r\nOff',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected6.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected6[buttonIndex] = true;
                } else {
                  isSelected6[buttonIndex] = false;
                }
                print("Laser light : ${isSelected6}");

                if (isSelected6[0]) {
                  _laserLight = 'On';
                } else {
                  _laserLight = 'Off';
                }
              }
            });
          },
          isSelected: isSelected6,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_normal_release_keep() {
    return Container(
      margin: EdgeInsets.only(
        left: 6,
      ),
      height: 30,
      //color: Colors.pink,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ToggleButtons(
          fillColor: Colors.lightGreen,
          selectedColor: Colors.purple,
          borderColor: Colors.blueGrey,
          borderWidth: 2,
          selectedBorderColor: Colors.blue,
          splashColor: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          children: [
            Text('Normal',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Release',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Keep',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected5.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected5[buttonIndex] = true;
                } else {
                  isSelected5[buttonIndex] = false;
                }
                print("Normal Release Keep : ${isSelected5}");

                if (isSelected5[0]) {
                  _mode2 = 'Normal';
                }

                if (isSelected5[1]) {
                  _mode2 = 'Release';
                }

                if (isSelected5[2]) {
                  _mode2 = 'Keep';
                }
              }
            });
          },
          isSelected: isSelected5,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_airwash() {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
      ),
      height: 30,
      //color: Colors.pink,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ToggleButtons(
          fillColor: Colors.lightGreen,
          selectedColor: Colors.purple,
          borderColor: Colors.blueGrey,
          borderWidth: 2,
          selectedBorderColor: Colors.blue,
          splashColor: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          children: [
            Text('No',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('1times',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('2times',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('3times',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected4.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected4[buttonIndex] = true;
                } else {
                  isSelected4[buttonIndex] = false;
                }
                print("Air-Wash : ${isSelected4}");

                if (isSelected4[0]) {
                  _airWash = '0';
                }

                if (isSelected4[1]) {
                  _airWash = '1';
                }

                if (isSelected4[2]) {
                  _airWash = '2';
                }

                if (isSelected4[3]) {
                  _airWash = '3';
                }
              }
            });
          },
          isSelected: isSelected4,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_InertGas() {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
      ),
      height: 30,
      //color: Colors.pink,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ToggleButtons(
          fillColor: Colors.lightGreen,
          selectedColor: Colors.purple,
          borderColor: Colors.blueGrey,
          borderWidth: 2,
          selectedBorderColor: Colors.blue,
          splashColor: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          children: [
            Text('No',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Argon',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Nitrogen',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected3.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected3[buttonIndex] = true;
                } else {
                  isSelected3[buttonIndex] = false;
                }
                print("Inert-Gas : ${isSelected3}");

                if (isSelected3[0]) {
                  _inertGas = 'No';
                }

                if (isSelected3[1]) {
                  _inertGas = 'Argon';
                }

                if (isSelected3[2]) {
                  _inertGas = 'Nitrogen';
                }
              }
            });
          },
          isSelected: isSelected3,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_manual_auto_button() {
    return Container(
      margin: EdgeInsets.only(
        left: 6,
      ),
      height: 30,
      //color: Colors.pink,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ToggleButtons(
          fillColor: Colors.lightGreen,
          selectedColor: Colors.purple,
          borderColor: Colors.blueGrey,
          borderWidth: 2,
          selectedBorderColor: Colors.blue,
          splashColor: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          children: [
            Text('Manual',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Auto',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected2.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected2[buttonIndex] = true;
                } else {
                  isSelected2[buttonIndex] = false;
                }
                print("Manaul Auto : ${isSelected2}");
                if (isSelected2[0]) {
                  _mode1 = 'Manual';
                } else {
                  _mode1 = 'Auto';
                }
              }
            });
          },
          isSelected: isSelected2,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_recommend_to_fill() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 2),
      child: Text('[⭐] = Recommend to fill in blank to upload data to SV',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.black)),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget buildTitle_with_backgroundColor_tempcontroller() {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      color: Colors.purple[200],
      height: 20,
      child: Center(
        child: Text(
          'TEMP.CONTROLLER',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget buildTitle_with_backgroundColor(
      String msg, double left_, double right_, double top_, Color x, double w) {
    return Container(
      margin: EdgeInsets.only(left: left_, right: right_, top: top_),
      height: 20,
      width: w,
      color: x,
      child: Center(
        child: Text(
          msg,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget buildTitle(String msg, double left_, double top_) {
    return Container(
      margin: EdgeInsets.only(left: left_, top: top_),
      //color: Colors.amberAccent,
      child: Text(
        msg,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_casting_keep_time(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 5),
      height: 30,
      width: 90,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Casting Keep Time',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('sec'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_casting_range_degree(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 5),
      height: 30,
      width: 90,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Casting Range Degree',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('℃'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_p(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 5),
      height: 30,
      width: 90,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'P',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //suffix: Text('rpm'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_i(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 5),
      height: 30,
      width: 90,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'I',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //suffix: Text('rpm'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_d(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 5),
      height: 30,
      width: 90,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'D',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //suffix: Text('rpm'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_emissivity(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 12, right: 6, top: 5),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Emissivity',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('rpm'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_zero_point_adjust(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 5),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Zero Point Adjust',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('kPa'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_arm_origin_speed(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 5),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'ARM Origin Speed',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('rpm'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_origin_point(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 5),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Origin Point',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //suffix: Text('sec'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_exh_timing(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'EXH-Timing',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('sec'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_rotation_time(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Rotation Time',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('sec'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_pressure_pv(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Pressure PV',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('kPa'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_rotation(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Rotation',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('rpm'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_acceleration(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Accelerarion',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('sec'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_s_curve(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'S-Curve',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //suffix: Text('%'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_max_heatpower(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'Max Heat Power',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('%'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_temp_setting(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      height: 30,
      width: 120,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        //maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: 'TEMP. Seting Value',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          suffix: Text('℃'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_weight(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 3,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: '⭐ WEIGHT',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //prefixIcon: Icon(Icons.star,color: Colors.yellow, size: 16),
          suffix: Text('℃'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_flask_temp(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 4,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: '⭐ FLASK TEMP',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //prefixIcon: Icon(Icons.star,color: Colors.yellow, size: 16),
          suffix: Text('℃'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_alloy(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 15,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: '⭐ ALLOY',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //prefixIcon: Icon(Icons.star,color: Colors.yellow, size: 16),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_design_code(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 15,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(2),
          labelText: '⭐ DESIGN CODE',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          //prefixIcon: Icon(Icons.star,color: Colors.yellow, size: 16),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_jobid(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 15,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2),
            labelText: '⭐ JOB ID',
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            counterText: "",
            //prefixIcon: Icon(Icons.star,color: Colors.yellow, size: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: MyConstant.dark)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: MyConstant.light)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.red)),
            errorStyle: TextStyle(height: 0)),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_recipe_name(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 210,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 17,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: 'Recipe name',
          contentPadding: EdgeInsets.all(2),
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          counterText: "",
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
          errorStyle: TextStyle(height: 0),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Container build_uploadtbutton() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 125,
      //color: Colors.red,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        gradient: RadialGradient(
            //stops: [0.0, 1],
            radius: 1.5,
            colors: [
              Colors.white,
              Colors.lightBlueAccent.shade100,
              Colors.blueAccent
            ],
            center: Alignment.center,
            tileMode: TileMode.clamp),
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          if (formkey.currentState!.validate()) {
            if ((_machineName != 'VCCxx') && (_serialNumber != 'S/N:')) {
              // Count row <= 20
              await SQLiteHeltper()
                  .getCount(SQLiteHeltper().tbl_vcc_castlog)
                  .then((value) async {
                if (value! > 20) {
                  popup_error('Please delete 1 Recipe to save the current Recipe.');
                  print("Please delete 1 Recipe to save the current Recipe.");
                } else {
                  //1. Insert to MySQL
                  processInsertOrUpdateMySQL().then((value) {});

                  // SQLite
                  //1.Count row first
                  await SQLiteHeltper()
                      .getCountVccCastLog(recipe_name.text)
                      .then((value) {
                    print('Count Row VCC CastLog: $value');

                    if (value! > 0) {
                      // Update
                      processUpdateSQLite_VccCastLog();
                      print("UPDATE");
                    } else {
                      //2. Insert to SQLite
                      processInsertSQLite_VccCastLog();
                      print("INSERT");
                    }

                    print("Upload");
                  });
                }
              });
            } else {
              popup_error('Please select the machine.');
            }
          } else {
            popup_error(
                'Please fill out the information correctly and completely.');
          }
        },
        icon: Icon(Icons.cloud_upload_rounded,
            color: Colors.white), //icon data for elevated button
        label: Text(
          "UPLOAD",
          style: TextStyle(
              color: Colors.black, fontSize: 13.5, fontWeight: FontWeight.bold),
        ), //label text
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Container build_recipelistbutton() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 60,
      //color: Colors.red,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        gradient: RadialGradient(
            //stops: [0.0, 1],
            radius: 1.5,
            colors: [Colors.white, Colors.amberAccent.shade100, Colors.amber],
            center: Alignment.center,
            tileMode: TileMode.clamp),
        color: Colors.amberAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        child: Text("Recipe List",
            style: TextStyle(
                color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        ),
        onPressed: () async {
          //processReadSQLite_VccCastLog();
          //processReadSQLite_VccCastLog_GET_RecipeName();

          final String xxx = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => RecipeList()));

          print(xxx);

          setState(() {
            GET_DataSQLite(xxx).then((value) {
              _machineName = recipe_list_model[0].machine_name;
              selectedValue = _machineName;

              _serialNumber = 'S/N:${recipe_list_model[0].serial}';
              recipe_name.text = recipe_list_model[0].recipe_name;

              job_id.text = recipe_list_model[0].job_id;
              design_code.text = recipe_list_model[0].design_code;
              alloy.text = recipe_list_model[0].alloy;
              flask_temp.text = recipe_list_model[0].flask_temp;
              weight_.text = recipe_list_model[0].weight;

              // Wax Wax3D Resin
              _wax = recipe_list_model[0].wax;
              _wax3D = recipe_list_model[0].wax_3d;
              _resin = recipe_list_model[0].resin;

              if (_wax == '1') {
                isSelected1[0] = true;
              } else {
                isSelected1[0] = false;
              }

              if (_wax3D == '1') {
                isSelected1[1] = true;
              } else {
                isSelected1[1] = false;
              }

              if (_resin == '1') {
                isSelected1[2] = true;
              } else {
                isSelected1[2] = false;
              }

              // Mode1
              _mode1 = recipe_list_model[0].mode1;
              if (_mode1 == 'Manual') {
                isSelected2[0] = true;
                isSelected2[1] = false;
              } else {
                isSelected2[0] = false;
                isSelected2[1] = true;
              }

              temp_setting_value.text = recipe_list_model[0].temp_setting_value;
              max_heat_power.text = recipe_list_model[0].max_heat_power;
              s_curve.text = recipe_list_model[0].s_curve;
              acceleration.text = recipe_list_model[0].acceleration;
              rotation.text = recipe_list_model[0].rotation;
              pressure_pv.text = recipe_list_model[0].pressure_pv;
              rotation_time.text = recipe_list_model[0].rotation_time;
              exh_timing.text = recipe_list_model[0].exh_timing;

              // Inert Gas
              _inertGas = recipe_list_model[0].inert_gas;
              if (_inertGas == 'No') {
                isSelected3[0] = true;
                isSelected3[1] = false;
                isSelected3[2] = false;
              } else if (_inertGas == 'Argon') {
                isSelected3[0] = false;
                isSelected3[1] = true;
                isSelected3[2] = false;
              } else if (_inertGas == 'Nitrogen') {
                isSelected3[0] = false;
                isSelected3[1] = false;
                isSelected3[2] = true;
              }

              // Air Wash
              _airWash = recipe_list_model[0].airwash;
              if (_airWash == '0') {
                isSelected4[0] = true;
                isSelected4[1] = false;
                isSelected4[2] = false;
                isSelected4[3] = false;
              } else if (_airWash == '1') {
                isSelected4[0] = false;
                isSelected4[1] = true;
                isSelected4[2] = false;
                isSelected4[3] = false;
              } else if (_airWash == '2') {
                isSelected4[0] = false;
                isSelected4[1] = false;
                isSelected4[2] = true;
                isSelected4[3] = false;
              } else if (_airWash == '3') {
                isSelected4[0] = false;
                isSelected4[1] = false;
                isSelected4[2] = false;
                isSelected4[3] = true;
              }

              // Mode2
              _mode2 = recipe_list_model[0].mode2;
              if (_mode2 == 'Normal') {
                isSelected5[0] = true;
                isSelected5[1] = false;
                isSelected5[2] = false;
              } else if (_mode2 == 'Release') {
                isSelected5[0] = false;
                isSelected5[1] = true;
                isSelected5[2] = false;
              } else if (_mode2 == 'Keep') {
                isSelected5[0] = false;
                isSelected5[1] = false;
                isSelected5[2] = true;
              }

              origin_point.text = recipe_list_model[0].origin_point;
              arm_origin_speed.text = recipe_list_model[0].arm_origin_speed;
              zero_point_adjust.text = recipe_list_model[0].zero_point_adjust;

              // // Laser light
              _laserLight = recipe_list_model[0].laser_light;
              if (_laserLight == 'On') {
                isSelected6[0] = true;
                isSelected6[1] = false;
              } else {
                isSelected6[0] = false;
                isSelected6[1] = true;
              }

              emissivity.text = recipe_list_model[0].emissivity;
              casting_keep_time.text = recipe_list_model[0].casting_keep_time;
              casting_range_degree.text =
                  recipe_list_model[0].casting_range_degree;
              p_.text = recipe_list_model[0].p;
              i_.text = recipe_list_model[0].i;
              d_.text = recipe_list_model[0].d;
            });
          });
        },
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Container build_serialnumber() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 76,
      color: Colors.lightBlueAccent,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          _serialNumber!,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_selectMachine(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 110,
      //color: Colors.red,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Icon(
                Icons.list,
                size: 14,
                color: Colors.black,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'M/C name',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: listMachineName
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              process_count_row_ServerConfig();

              selectedValue = value;
              _machineName = selectedValue;

              int selectedIndex = listMachineName.indexOf(selectedValue!);
              _serialNumber = 'S/N:' + listSerial[selectedIndex];

              //print('Select Machine Index: ${listMachineName.indexOf(selectedValue!)}');
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 100,
            padding: const EdgeInsets.only(left: 6, right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: MyConstant.dark,
              ),
              color: Colors.lightBlueAccent,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 12,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Colors.lightBlueAccent,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(30),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 30,
            padding: EdgeInsets.only(left: 6, right: 6),
          ),
        ),
      ),
    );
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}
