import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pagesNotAuth/ArticlesPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompaniesPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/securityFlows/LoginPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/securityFlows/RegisterPage.dart';

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
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/news': (context) => const ArticlesPage(),
        '/personal-areas':(context) => const ArticlesPage(),
        '/registration': (context) => const RegisterPage() 
      },

    );
  }

}