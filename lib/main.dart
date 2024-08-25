import 'package:flutter/material.dart';
import 'package:vccinputtablet/states/home.dart';
import 'package:vccinputtablet/states/input.dart';
import 'package:vccinputtablet/states/recipelist.dart';
import 'package:vccinputtablet/states/setting_db.dart';
import 'package:vccinputtablet/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/homepage':(BuildContext context) => Homepage(),
  '/inputpage':(BuildContext context) => InputForm(),
  '/recipelistpage':(BuildContext context) => RecipeList(),
  '/settingDBpage':(BuildContext context) => SettingDB(),
};

String? initialRoute ;

void main() {
  initialRoute = MyConstant.routeHomepage;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
    );
  }
}


// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }
