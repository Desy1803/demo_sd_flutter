import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/ArticleResponse.dart';
import 'package:flutter_application_sd/dtos/SearchArticleCriteria.dart';
import 'package:flutter_application_sd/pagesAuth/WriteArticle.dart';
import 'package:flutter_application_sd/pagesNotAuth/ArticleDetailedPage.dart';
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

  // Aggiungi le categorie e le date per i filtri
  final List<String> categories = ['All', 'Tech', 'Health', 'Business'];
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

    // Carica gli articoli
    List<ArticleResponse>? loadedArticles = await Model.sharedInstance.getPublicArticles(
      criteria: searchCriteria,
    );

    // Gestisci il risultato
    setState(() {
      if (loadedArticles != null && loadedArticles.isNotEmpty) {
        // Ordina gli articoli per titolo
        articles = loadedArticles..sort((a, b) => a.title.compareTo(b.title));
      } else {
        errorMessage = 'No articles found.';
      }
      isLoading = false;
    });
  } catch (e) {
    // Gestisci eventuali errori
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

  // Costruzione della barra di ricerca
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

  // Menu a tendina per i filtri
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

  // Sezione degli articoli
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
      return Center(
        child: Text(
          'No articles available.',
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: articles!.length,
      itemBuilder: (context, index) {
        return _buildArticleCard(articles![index]);
      },
    );
  }

  // Card per visualizzare gli articoli
  Widget _buildArticleCard(ArticleResponse article) {
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
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(article.company ?? 'No Company'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailedPage(
                article: article,
              ),
            ),
          );
        },
      ),
    );
  }
}
