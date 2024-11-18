import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/pagesNotAuth/ArticleDetailedPage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}
class _ArticlesPageState extends State<ArticlesPage> {
  List<Article> articles = [];
  int? tappedIndex;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      List<Article>? loadedArticles = await Model.sharedInstance.getPublicArticles();

      setState(() {
        if (loadedArticles != null && loadedArticles.isNotEmpty) {
          articles = loadedArticles..sort((a, b) => a.title.compareTo(b.title));
        } else {
          errorMessage = 'No articles found.';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading articles: ${e.toString()}';
        isLoading = false;
      });
      print('Error loading articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : articles.isEmpty
                  ? const Center(
                      child: Text(
                        'No articles available.',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,  // Due articoli per riga
                        childAspectRatio: 0.65,  // Ridurre la dimensione del riquadro
                        crossAxisSpacing: 6.0,  // Spazio più piccolo tra gli articoli
                        mainAxisSpacing: 6.0,  // Spazio più piccolo tra le righe
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                    child: article.imageUrl != null
                                        ? Image.network(
                                            article.imageUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                        : Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 10.0,
                                                color: Colors.grey,
                                              ),
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
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    article.description ?? 'No description available.',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
