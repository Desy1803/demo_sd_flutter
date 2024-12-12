import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/dtos/ArticleResponse.dart';
import 'package:flutter_application_sd/pagesAuth/PersonalArea.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
import 'dart:html' as html;


class GeneratedArticlePage extends StatefulWidget {
  final ArticleResponse article;

  const GeneratedArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  _GeneratedArticlePageState createState() => _GeneratedArticlePageState();
}

class _GeneratedArticlePageState extends State<GeneratedArticlePage> {
  late TextEditingController titleController;
  late TextEditingController companyController;
  late TextEditingController descriptionController;
  late TextEditingController fiscalYearController;
  late TextEditingController categoryController;

  String? imagePreviewUrl;
  String imageUrl = '';
  final bool isAIEnabled = true;
  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.article.title);
    companyController = TextEditingController(text: widget.article.company);
    descriptionController = TextEditingController(text: removeAsterisks(widget.article.description));
    fiscalYearController = TextEditingController(text: widget.article.date);
    categoryController = TextEditingController(text: widget.article.category);
    isPublic = widget.article.isPublic;
  }

  String removeAsterisks(String text) {
    return text.replaceAll('*', '').trim();
  }

  Future<void> saveArticle() async {
    if (titleController.text.isEmpty ||
        companyController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        fiscalYearController.text.isEmpty ||
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
      company: companyController.text,
      author: "ciao",
      timeUnit: fiscalYearController.text,
      isPublic: isPublic,
      isAI: isAIEnabled,
      imageUrl: imageUrl,
      category: categoryController.text,
    );

    try {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PersonalArea()),
      );
    }
  }

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
        setState(() {
          imagePreviewUrl = reader.result as String;
          imageUrl = imagePreviewUrl!.split(',').last;
        });
      });
    });
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
              TextField(
                controller: companyController,
                decoration: const InputDecoration(
                  labelText: 'Company',
                  border: OutlineInputBorder(),
                ),
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
              TextField(
                controller: fiscalYearController,
                decoration: const InputDecoration(
                  labelText: 'Fiscal Year',
                  border: OutlineInputBorder(),
                ),
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
