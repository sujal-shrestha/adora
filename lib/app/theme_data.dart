import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.lightBlue,
    fontFamily: 'Inter Bold',
    appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 167, 178, 183),
        ),
 );
}
