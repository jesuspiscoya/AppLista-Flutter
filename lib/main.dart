import 'package:flutter/material.dart';
import 'package:lista_app/pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soyami Shop App',
      home: HomePage(index: 0),
    );
  }
}
