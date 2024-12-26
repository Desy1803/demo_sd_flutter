import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/ArticleResponse.dart';
import 'package:flutter_application_sd/dtos/SearchArticleCriteria.dart';
import 'package:flutter_application_sd/pagesNotAuth/ArticleDetailedPage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
import 'package:flutter_application_sd/widgets/LoginRecommendationPopup.dart';
import 'WriteArticle.dart';

class PersonalArea extends StatefulWidget {
  @override
  _PersonalAreaState createState() => _PersonalAreaState();
}

class _PersonalAreaState extends State<PersonalArea> {
  List<ArticleResponse>? yourArticles;
  String searchQuery = "";
  String? selectedCategory;
  String? selectedDate;
  bool isLoadingPublic = true;
  bool isLoadingPrivate = true;
  String? errorMessagePublic;
  String? errorMessagePrivate;

  final List<String> categories = ['All', 'Fundamental Data', 'Financial Data', 'Annual Reports', 'Profitability & Margins', 'Revenue & Growth', 'Analyst Ratings'];
  final List<String> dates = ['All', 'Last Week', 'Last Month', 'Last Year'];

  @override
  void initState() {
    super.initState();
    _loadYourArticles();
  }

  Future<void> _loadYourArticles() async {
    setState(() {
      isLoadingPublic = true;
      errorMessagePublic = null;
    });

    SearchArticleCriteria searchCriteria = SearchArticleCriteria(
      title: searchQuery,
      category: selectedCategory,
      date: selectedDate,
      isPublic: null
    );

    try {
      List<ArticleResponse>? yourArticlesResult = await Model.sharedInstance.getUserArticles(criteria: searchCriteria);
      setState(() {
        yourArticles = yourArticlesResult ?? [];
      });
    } catch (e) {
      setState(() {
        errorMessagePublic = 'Error loading public articles: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoadingPublic = false;
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
    if (!Model.sharedInstance.isAuthenticated()) {
      return const LoginRecommendationPopup();
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

              _buildFilterMenu(),
              _buildSection(
                title: "Your Articles",
                articles: yourArticles,
                isLoading: isLoadingPublic,
                errorMessage: errorMessagePublic,
                allowEditAndDelete: true,
              ),
              SizedBox(height: 24),

             
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
      onChanged: (query) async {
        searchQuery = query;
        _loadYourArticles();
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
          onChanged: (value) async {
            selectedCategory = value;
            _loadYourArticles();
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
          onChanged: (value) async {
            selectedDate = value;
            _loadYourArticles();
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    List<ArticleResponse>? articles,
    required bool isLoading,
    String? errorMessage,
    required bool allowEditAndDelete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.blueAccent),
        ),
        if (isLoading)
          Center(child: CircularProgressIndicator())
        else if (errorMessage != null)
          Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
        else if (articles == null || articles.isEmpty)
          Center(child: Text("No articles found"))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return _buildArticleCard(articles[index], allowEditAndDelete);
            },
          ),
      ],
    );
  }

  Widget _buildArticleCard(ArticleResponse article, bool allowEditAndDelete) {
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
                allowEdit: allowEditAndDelete,
                allowDelete: allowEditAndDelete,
              ),
            ),
          );
        },
      ),
    );
  }
}
