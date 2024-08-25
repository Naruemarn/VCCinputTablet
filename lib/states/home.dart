import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vccinputtablet/states/input.dart';
import 'package:vccinputtablet/states/setting_db.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VCC Input Data',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InputForm()),
                );
              },
              icon: const Icon(
                Icons.keyboard_outlined,
                color: Colors.white,
                size: 25,
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingDB()),
                );
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
      body: SafeArea(
        child: Text('This is Homepage'),
      ),
    );
  }
}
