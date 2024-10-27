import 'package:flutter/material.dart';
import 'package:veterinaria_web_front/design/app_colors.dart';
import 'package:veterinaria_web_front/pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veterinaria Web Front',
      theme: ThemeData.light().copyWith(
        extensions: const[AppColors(
          dark: Color(0xFF292b2c),
          light: Color(0xFFf3fefe),
          mainColor: Color.fromARGB(255, 107, 164, 163),
          secondColor: Color(0xFFb4e6e3),
          highlightColor: Color(0xFFd8eceb),
        )],
        inputDecorationTheme: const InputDecorationTheme(
          /* border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ), */
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 107, 164, 163),
            ),
          ),
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 107, 164, 163),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor:  const Color.fromARGB(255, 107, 164, 163),
            foregroundColor: const Color(0xff292b2c),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),)
      ),
      home: LogInPage(),
    );
  }
}

