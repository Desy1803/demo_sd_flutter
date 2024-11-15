import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pages/ArticlesPage.dart';
import 'package:flutter_application_sd/pages/CompaniesPage.dart';
import 'package:flutter_application_sd/pages/LoginPage.dart';
import 'package:flutter_application_sd/pages/RegisterPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Trading reports",
      home: CompaniesPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/news': (context) => const ArticlesPage(),
        '/personal-areas':(context) => const ArticlesPage(),
        '/registration': (context) => const RegisterPage() 
      },

    );
  }

}