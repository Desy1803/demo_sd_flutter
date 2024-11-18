import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/pagesNotAuth/ArticleDetailedPage.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';


class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<Article> articles = [];
  int? tappedIndex;

  @override
  void initState() {
    super.initState();
    fetchMockArticles(); 
  }

  void fetchMockArticles() {
    articles = [
      Article(
        title: 'Article 1',
        description: 'This is the description for Article 1.',
        imageUrl: 'https://picsum.photos/id/237/200/300',
      ),
      Article(
        title: 'Article 2',
        description: 'This is the description for Article 2.',
        imageUrl: 'https://picsum.photos/id/250/200/300',
      ),
      Article(
        title: 'Article 3',
        description: 'This is the description for Article 3.',
        imageUrl: 'https://picsum.photos/id/117/200/300',
      ),
      Article(
        title: 'Article 4',
        description: 'This is the description for Article 4.',
      ),
      Article(
        title: 'Article 5',
        description: 'This is the description for Article 5.',
        imageUrl: 'https://picsum.photos/20/300?image=3',
      ),
      Article(
        title: 'Article 6',
        description: 'This is the description for Article 6.',
        imageUrl: 'https://picsum.photos/seed/picsum/200/300',
      ),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Articles',
      ),
      body: articles.isEmpty
          ? Center(child: CircularProgressIndicator()) 
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                childAspectRatio: 0.5, 
              ),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                Article article = articles[index]; 

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tappedIndex = index;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailedPage(article: article),
                      ),
                    ).then((_) {
                      setState(() {
                        tappedIndex = null; 
                      });
                    });
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: article.imageUrl != null
                              ? Image.network(
                                  article.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Container(
                                  color: Colors.grey[200], 
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      article.description ?? 'No description available',
                                      style: const TextStyle(fontSize: 14.0),
                                      maxLines: 3, 
                                      overflow: TextOverflow.ellipsis, 
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            article.title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
