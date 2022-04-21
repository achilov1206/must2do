import 'package:flutter/material.dart';

final initialTheme = ThemeData(
    primaryColor: Colors.green,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      toolbarTextStyle: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleTextStyle: TextStyle(
        fontSize: 26,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.grey,
        size: 30,
      ),
      iconTheme: IconThemeData(
        color: Colors.grey,
        size: 30,
      ),
      elevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.green.withOpacity(0.1);
            }
            if ((states.contains(MaterialState.focused)) ||
                (states.contains(MaterialState.pressed))) {
              return Colors.green.withOpacity(0.2);
            }
            return null;
          })),
    ),
    scaffoldBackgroundColor: Colors.grey[200],
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(size: 30),
      unselectedIconTheme: IconThemeData(size: 30),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.green,
    ));
