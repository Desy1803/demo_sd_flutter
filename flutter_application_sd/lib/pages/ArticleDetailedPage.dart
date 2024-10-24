import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/pages/LoginPage.dart';

class ArticleDetailedPage extends StatelessWidget {
  final Article article;
  ArticleDetailedPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        leading: IconButton(
          icon: Icon(Icons.account_box),
          onPressed: () {
            // Navigate to LoginPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(article.description),
      ),
    );
  }
}