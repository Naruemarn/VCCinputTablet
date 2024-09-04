import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vccinputtablet/states/home.dart';
import 'package:vccinputtablet/states/recipelist.dart';
import 'package:vccinputtablet/states/setting_db.dart';
import 'package:vccinputtablet/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/homepage':(BuildContext context) => Homepage(),
  //'/inputpage':(BuildContext context) => InputForm(),
  '/recipelistpage':(BuildContext context) => RecipeList(),
  '/settingDBpage':(BuildContext context) => SettingDB(),
};

String? initialRoute ;

void main() {
  initialRoute = MyConstant.routeHomepage;

  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();


  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
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

