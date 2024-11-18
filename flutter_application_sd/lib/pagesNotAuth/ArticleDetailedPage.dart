import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class ArticleDetailedPage extends StatelessWidget {
  final Article article;
  ArticleDetailedPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(article.description),
      ),
    );
  }
}