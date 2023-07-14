import 'package:flutter/material.dart';
import 'package:to_do/pages/home.dart';
import 'package:to_do/pages/mainscreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.deepOrange,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => MainScreen(),
      '/todo': (context) => Home()
    },
  ));
}