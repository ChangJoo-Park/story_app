import 'package:flutter/material.dart';

ThemeData getTheme({String themeName = 'default'}) {
  ThemeData themeData;
  switch (themeName) {
    case 'dark':
      break;
    default:
      themeData = ThemeData(
        primaryColor: Colors.grey.shade50,
        fontFamily: 'Mapo금빛나루',
        accentColor: Colors.grey.shade50,
        appBarTheme: AppBarTheme(
          color: Colors.grey.shade50,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey.shade800),
          textTheme: TextTheme(
            headline6:
                TextStyle(color: Colors.grey.shade600, fontFamily: 'Mapo금빛나루'),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey.shade800,
        ),
      );
      break;
  }
  return themeData;
}
