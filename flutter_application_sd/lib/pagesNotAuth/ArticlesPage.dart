import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/ArticleResponse.dart';
import 'package:flutter_application_sd/dtos/SearchArticleCriteria.dart';
import 'package:flutter_application_sd/pagesAuth/WriteArticle.dart';
import 'package:flutter_application_sd/pagesNotAuth/ArticleDetailedPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/compact/CompactArticlesPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/compact/CompactCompaniesPage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<ArticleResponse>? articles = [];
  String searchQuery = "";
  String? selectedCategory;
  String? selectedDate;
  bool isLoading = true;
  String? errorMessage;

  final List<String> categories = [
    'All',
    'Fundamental Data',
    'Financial Data',
    'Analysis Data',
    'Profitability & Margins',
    'Revenue & Growth',
    'Analyst Ratings'
  ];
  final List<String> dates = ['All', 'Last Week', 'Last Month', 'Last Year'];

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

      SearchArticleCriteria searchCriteria = SearchArticleCriteria(
        title: searchQuery,
        category: selectedCategory,
        date: selectedDate,
      );

      List<ArticleResponse>? loadedArticles = await Model.sharedInstance.getPublicArticles(
        criteria: searchCriteria,
      );

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
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 500) {
      return CompactArticlesPage();  
    }
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 16.0),
              _buildFilterMenu(),
              SizedBox(height: 24.0),
              _buildArticleSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WriteArticlePage()),
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Color(0xFF001F3F),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (query) {
        setState(() {
          searchQuery = query;
        });
        _loadArticles();
      },
      decoration: InputDecoration(
        labelText: 'Search by Title',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFilterMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: selectedCategory,
          hint: Text("Category"),
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
            _loadArticles();
          },
        ),
        DropdownButton<String>(
          value: selectedDate,
          hint: Text("Date"),
          items: dates.map((date) {
            return DropdownMenuItem<String>(
              value: date,
              child: Text(date),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedDate = value;
            });
            _loadArticles();
          },
        ),
      ],
    );
  }

  Widget _buildArticleSection() {
  if (isLoading) {
    return Center(child: CircularProgressIndicator());
  }

  if (errorMessage != null) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorMessage!,
          style: TextStyle(fontSize: 16.0, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  if (articles!.isEmpty) {
    return const Center(
      child: Text(
        'No articles available.',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,  
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 1.6, 
    ),
    itemCount: articles!.length,
    itemBuilder: (context, index) {
      return _buildArticleCard(articles![index]);
    },
  );
}

Widget _buildArticleCard(ArticleResponse article) {
  return FutureBuilder<Uint8List?>(
    future: Model.sharedInstance.fetchArticleImage(article.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: SizedBox(
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
        return _buildCardWithoutImage(article);
      }

      return Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Column(
          children: [
            Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                article.title ?? 'No Title',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.business, color: Colors.blueGrey, size: 20),
                      const SizedBox(width: 8.0),
                      Text(
                        'Company: ${article.company}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.category, color: Colors.teal, size: 20),
                      const SizedBox(width: 8.0),
                      Text(
                        'Category: ${article.category}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailedPage(
                      article: article,
                      allowDelete: false,
                      allowEdit: false,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildCardWithoutImage(ArticleResponse article) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    elevation: 4,
    child: ListTile(
      contentPadding: EdgeInsets.all(16),
      title: Text(
        article.title ?? 'No Title',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: Colors.blueGrey, size: 20),
              const SizedBox(width: 8.0),
              Text(
                'Company: ${article.company}',
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
           Row(
            children: [
              const Icon(Icons.category, color: Colors.teal, size: 20),
              const SizedBox(width: 8.0),
              Text(
                'Category: ${article.category}',
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), 
          Text(
            article.description?.isNotEmpty == true
                ? article.description!  
                : 'No description available.',  
            style: TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 10,  
            overflow: TextOverflow.ellipsis, 
          ),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailedPage(
              article: article,
              allowDelete: false,
              allowEdit: false,
            ),
          ),
        );
      },
    ),
  );
}

}