import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pages/ArticlesPage.dart';
import 'package:flutter_application_sd/pages/CompaniesPage.dart';


class AppRoutes {
  static const String home = '/';
  static const String personalArea = '/personal-areas';
  static const String news = '/news';
  static const String about = '/about';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) =>  CompaniesPage());
      case personalArea:
        return MaterialPageRoute(builder: (_) => const ArticlesPage());
      case news:
        return MaterialPageRoute(builder: (_) => const ArticlesPage());
      //case about:
        //return MaterialPageRoute(builder: (_) => const AboutPage());
      default:
        // Rotta di fallback in caso di URL non valido
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}
