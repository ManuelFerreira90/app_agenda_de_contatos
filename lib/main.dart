import 'package:app_agenda/view/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.red,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.black),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.black)
            ),
            border: OutlineInputBorder(
               borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.black)
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.red,
            shape: CircleBorder(),
          )),
      home: const HomePage(),
    );
  }
}
