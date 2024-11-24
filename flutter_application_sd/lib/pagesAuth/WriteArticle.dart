import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/forms/ArticleForm.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class WriteArticlePage extends StatefulWidget {
  @override
  _WriteArticlePageState createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fiscalYearController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  String? imagePreviewUrl;
  String imageUrl = '';
  bool isPublic = true;
  bool isAIEnabled = false;

  Future<void> saveArticle() async {
    if (titleController.text.isEmpty ||
        companyController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        fiscalYearController.text.isEmpty ||
        categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    Article article = Article(
      id: 1,
      title: titleController.text,
      description: descriptionController.text,
      company: companyController.text,
      author: "author",
      timeUnit: fiscalYearController.text,
      isPublic: isPublic,
      isAI: isAIEnabled,
      imageUrl: imageUrl,
      category: categoryController.text,
    );

    try {
      Article? articleRet = await Model.sharedInstance.createArticle(article);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save article: $e')),
      );
    }
  }

  Future<void> createWithAI() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select AI Analysis Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Create your article on Fundamental Data'),
                onTap: () {
                  Navigator.pop(context);
                  fetchAIData('FUNDAMENTAL');
                },
              ),
              ListTile(
                title: Text('Create your article with Data Analysis'),
                onTap: () {
                  Navigator.pop(context);
                  fetchAIData('ANALYSIS');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchAIData(String aiType) async {
    // Mock API call to fetch AI-generated data
    try {
      final response = await Model.sharedInstance.fetchAIArticle(aiType);
      setState(() {
        titleController.text = response.title;
        descriptionController.text = response.description;
        companyController.text = response.company;
        fiscalYearController.text = response.timeUnit;
        categoryController.text = response.category;
        isAIEnabled = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI Data Loaded')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch AI data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArticleForm(
                titleController: titleController,
                companyController: companyController,
                descriptionController: descriptionController,
                fiscalYearController: fiscalYearController,
                categoryController: categoryController,
                imagePreviewUrl: imagePreviewUrl,
                onImageSelected: (dataUrl) {
                  setState(() {
                    imagePreviewUrl = dataUrl;
                    imageUrl = dataUrl.split(',').last;
                  });
                },
                isReadonly: isAIEnabled,
              ),
              Row(
                children: [
                  Checkbox(
                    value: isPublic,
                    onChanged: isAIEnabled
                        ? null
                        : (value) {
                            setState(() {
                              isPublic = value!;
                            });
                          },
                  ),
                  Text('Public Article'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF001F3F),
                    ),
                    onPressed: saveArticle,
                    child: Text("Save Article"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF001F3F),
                    ),
                    onPressed: isAIEnabled ? null : createWithAI,
                    child: Text(isAIEnabled ? "AI Enabled" : "Create with AI"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
