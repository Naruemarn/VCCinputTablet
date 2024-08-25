import 'package:flutter/material.dart';
import 'package:vccinputtablet/models/sqlite_model_server_setting.dart';
import 'package:vccinputtablet/utility/my_constant.dart';
import 'package:vccinputtablet/utility/sqlite_helper.dart';
import 'package:vccinputtablet/widgets/show_progress.dart';

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class SettingDB extends StatefulWidget {
  const SettingDB({super.key});

  @override
  State<SettingDB> createState() => _SettingDBState();
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class _SettingDBState extends State<SettingDB> {
  bool statusRedEye = true;

  final formkey = GlobalKey<FormState>();

  TextEditingController server = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController databasename = TextEditingController();

  List<SQLiteModelServerSetting> sqliteModels = [];
  int cnt_row = 0;
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processReadSQLite();
  }

  Future<Null> process_count_row(String ip) async {
    await SQLiteHeltper().getCount(ip).then((value) {
      print('Count Row: $value');
      setState(() {
        cnt_row = value!;
      });
    });
  }

  Future<Null> processReadSQLite() async {
    await SQLiteHeltper().readSQLite_serverSetting().then((value) {
      print('value on processReadSQLite ===> $value');
      setState(() {
        load = false;
        sqliteModels = value;
        server.text = sqliteModels[0].server;
        username.text = sqliteModels[0].username;
        password.text = sqliteModels[0].password;
        databasename.text = sqliteModels[0].databaseName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Server Setting',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        elevation: 25,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: load
          ? ShowProgress()
          : LayoutBuilder(
              builder: (context, constraints) => GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                behavior: HitTestBehavior.opaque,
                child: Form(
                  key: formkey,
                  child: Center(
                    child: ListView(
                      children: [
                        buildServer(constraints, server),
                        buildUsername(constraints, username),
                        buildPassword(constraints, password),
                        buildDatabaseName(constraints, databasename),
                        buildSaveButton(constraints),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Row buildServer(BoxConstraints constraints, TextEditingController inputbox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 32),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Server IP';
              } else {
                return null;
              }
            },
            //keyboardType: TextInputType.number,
            controller: inputbox,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              labelText: 'Server:',
              prefixIcon: Icon(
                Icons.cloud_queue_rounded,
                color: MyConstant.dark,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(30)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Row buildUsername(
      BoxConstraints constraints, TextEditingController inputbox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Username';
              } else {
                return null;
              }
            },
            //keyboardType: TextInputType.number,
            controller: inputbox,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              labelText: 'Username:',
              prefixIcon: Icon(
                Icons.account_circle_outlined,
                color: MyConstant.dark,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(30)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Row buildPassword(
      BoxConstraints constraints, TextEditingController inputbox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Password';
              } else {
                return null;
              }
            },
            //keyboardType: TextInputType.number,
            controller: inputbox,
            textAlign: TextAlign.start,
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(
                        Icons.remove_red_eye,
                        color: MyConstant.dark,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: MyConstant.dark,
                      ),
              ),
              labelText: 'Password:',
              prefixIcon: Icon(
                Icons.lock_outlined,
                color: MyConstant.dark,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(30)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }
  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  Row buildDatabaseName(
      BoxConstraints constraints, TextEditingController inputbox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Database name';
              } else {
                return null;
              }
            },
            //keyboardType: TextInputType.number,
            controller: inputbox,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              labelText: 'Database name:',
              prefixIcon: Icon(
                Icons.table_rows_sharp,
                color: MyConstant.dark,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(30)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Row buildSaveButton(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.4,
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.save,
              size: 40,
            ),
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                // ignore: avoid_print
                //print("Data: ${server.text} ${username.text} ${password.text} ${databasename.text}");

                //process_count_row(server.text);

                // 1.Delete
                SQLiteHeltper().delete();

                // 2.Insert
                SQLiteModelServerSetting data = SQLiteModelServerSetting(
                    server: server.text,
                    username: username.text,
                    password: password.text,
                    databaseName: databasename.text);
                await SQLiteHeltper()
                    .insertValueToSQLite(data)
                    .then((value) => Navigator.pop(context));
              }
            },
            label: Text(
              'Save',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, foregroundColor: Colors.white),
          ),
        ),
      ],
    );
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}
