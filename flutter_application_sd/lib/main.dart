import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pagesAuth/PersonalArea.dart';
import 'package:flutter_application_sd/pagesNotAuth/AboutUsPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompaniesPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/GlobalMarketStatusPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/compact/CompactCompaniesPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/securityFlows/ForgotPasswordPage.dart'; 
import 'package:flutter_application_sd/pagesNotAuth/securityFlows/LoginPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/ArticlesPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/securityFlows/RegisterPage.dart';
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return MaterialApp(
      title: "Trading Reports",
      home: screenWidth < 450 ? CompactCompaniesPage() : CompaniesPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/news': (context) => const ArticlesPage(),
        '/personal-areas':(context) => PersonalArea(),
        '/registration': (context) => const RegisterPage(),
        '/forgot-password':(context)=> ForgotPasswordPage(),
        '/global-status-market':(context) => GlobalMarketStatusPage(),
        '/about': (context) => AboutUsPage()
      },
    );
  }
}
