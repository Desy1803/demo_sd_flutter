import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/dtos/ArticleResponse.dart';
import 'package:flutter_application_sd/pagesAuth/PersonalArea.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
import 'dart:html' as html;

import 'package:flutter_application_sd/widgets/DateSelectort.dart';
import 'package:flutter_application_sd/widgets/CompanySelector.dart';

class GeneratedArticlePage extends StatefulWidget {
  final ArticleResponse article;
  final String? imagePreviewUrl;
  final String imageUrl;
  final DateTime date;

  const GeneratedArticlePage({
    Key? key,
    required this.article,
    required this.date,
    required this.imagePreviewUrl,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _GeneratedArticlePageState createState() => _GeneratedArticlePageState();
}

class _GeneratedArticlePageState extends State<GeneratedArticlePage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;

  DateTime? selectedDate;
  String? imagePreviewUrl;
  String imageUrl = '';
  final bool isAIEnabled = true;
  bool isPublic = true;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.article.title);
    descriptionController = TextEditingController(text: cleanDescription(widget.article.description));
    categoryController = TextEditingController(text: widget.article.category);
    isPublic = widget.article.isPublic;
    imagePreviewUrl = widget.imagePreviewUrl;
    imageUrl = widget.imageUrl;
    selectedDate = widget.date; // Initial selected date
  }

  String cleanDescription(String text) {
    text = text.replaceAll(RegExp(r'â'), '’');
    text = text.replaceAll(RegExp(r'â€œ'), '“');
    text = text.replaceAll(RegExp(r'â€'), '”');
    text = text.replaceAll('*', '').trim();
    return text;
  }

  // Save article method
  Future<void> saveArticle() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate == null || // Make sure a date is selected
        categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    Article article = Article(
      id: widget.article.id,
      title: titleController.text,
      description: descriptionController.text,
      company: widget.article.company,
      author: "ciao",
      timeUnit: selectedDate!.toString(), // Store the selected date as a string
      isPublic: isPublic,
      isAI: isAIEnabled,
      imageUrl: imageUrl,
      category: categoryController.text,
    );

    try {
      setState(() {
        isLoading = true;
      });
      await Model.sharedInstance.createArticle(article);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article saved successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PersonalArea()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save article: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle image upload
  void handleImageUpload() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsDataUrl(files[0]);
      reader.onLoadEnd.listen((e) {
        if (mounted) {
          // Check if the widget is still mounted before calling setState
          setState(() {
            imagePreviewUrl = reader.result as String;
            imageUrl = imagePreviewUrl!.split(',').last;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generated Article',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001F3F),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CompanySelector(
                      selectedCompany: widget.article.company,
                      onCompanySelected: (_) {},
                      isEditable: false, // Disable editing
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter article description...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DateSelector(
                      selectedDate: selectedDate,
                      onDateSelected: (pickedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (imagePreviewUrl != null)
                      Column(
                        children: [
                          const Text('Image Preview:'),
                          const SizedBox(height: 8),
                          Image.network(imagePreviewUrl!),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: handleImageUpload,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001F3F),
                      ),
                      child: const Text('Upload Image', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isPublic,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value!;
                            });
                          },
                        ),
                        const Text('Public Article'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: saveArticle,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          backgroundColor: const Color(0xFF001F3F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Save Article",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
