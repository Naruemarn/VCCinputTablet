import 'package:flutter/material.dart';

class MyConstant {
  // General
  static String appName = 'vccinputdata';

  // Route
  static String routeHomepage = '/homepage';
  static String routeInputpage = '/inputpage';
  static String routeRecipelistpage = '/recipelistpage';
  static String routeSettingDBpage = '/settingDBpage';

  // Image
  static String image1 = 'images/image1.png';

  // Color
  static Color primary = Colors.teal;
  static Color dark = Color(0xff575900);
  static Color light = Color(0xFFB9B64E);

  // Style
  TextStyle h1Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);

  TextStyle h2Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);

  TextStyle h3Style() =>
      TextStyle(fontSize: 14, color: dark, fontWeight: FontWeight.normal);

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
