import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/pagesAuth/AiWidget.dart';
import 'package:flutter_application_sd/pagesAuth/PersonalArea.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CompanySelector.dart';
import 'package:flutter_application_sd/widgets/CategorySelector.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
import 'package:flutter_application_sd/widgets/DateSelectort.dart';
import 'package:flutter_application_sd/widgets/LoginRecommendationPopup.dart';

class WriteArticlePage extends StatefulWidget {
  String? selectedCompany;
  String? symbol;
  String? category;
  DateTime? selectedDate;
  dynamic articleData;

  WriteArticlePage({this.symbol, this.selectedCompany, this.category, this.selectedDate, this.articleData});

  @override
  _WriteArticlePageState createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isPublic = true;
  bool isAIEnabled = false;
  String? symbol;
  String? selectedCompany;
  String? selectedCategory;
  DateTime? selectedDate;
  String imageUrl = '';
  String? imagePreviewUrl;
  dynamic articleData;

  @override
  void initState() {
    super.initState();
    selectedCompany = widget.selectedCompany;
    selectedCategory = widget.category;
    selectedDate = widget.selectedDate;
    articleData = widget.articleData;
    symbol = widget.symbol;
 
  }

  Future<void> saveArticle() async {
    if (titleController.text.isEmpty ||
        selectedCompany == null ||
        descriptionController.text.isEmpty ||
        selectedCategory == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    Article article = Article(
      id: 1,
      title: titleController.text,
      description: descriptionController.text,
      company: selectedCompany!,
      author: "author",
      timeUnit: selectedDate!.toString(),
      isPublic: isPublic,
      isAI: isAIEnabled,
      imageUrl: imageUrl,
      category: selectedCategory!,
    );

    try {
      Article? articleRet = await Model.sharedInstance.createArticle(article);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article saved successfully!')),
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
      if (mounted) {  
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

  if (!Model.sharedInstance.isAuthenticated()) {
    return const LoginRecommendationPopup();
  }
  return Scaffold(
    appBar: CustomAppBar(),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Your Article',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001F3F),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '* Required fields',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            CompanySelector(
              selectedCompany: selectedCompany,
              onCompanySelected: (value) {
                setState(() {
                  selectedCompany = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CategorySelector(
              selectedCategory: selectedCategory,
              onCategorySelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              visibleAnalysis: articleData!=null,
            ),
            const SizedBox(height: 16),
            DateSelector(
              initialYear: selectedDate?.year ?? DateTime.now().year,
              startYear: 2008,
              endYear: DateTime.now().year,
              onYearSelected: (year) {
                setState(() {
                  selectedDate = DateTime(year, 12, 31);
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Want to make it easier? You can use AI to create your article:',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF001F3F),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                if (selectedCompany == null ||
                    selectedCategory == null ||
                    selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all required fields.')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateArticleWithAIWidget(
                      data: articleData,
                      selectedCategory: selectedCategory,
                      selectedCompany: selectedCompany,
                      selectedDate: selectedDate,
                      imagePreviewUrl: imagePreviewUrl,
                      imageUrl: imageUrl,
                      isCompanyEditable: false,
                      isCategoryEditable: true,
                    ),
                  ),
                );
              },
              child: const Text(
                'Try creating your article with AI',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF001F3F),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title*',
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF001F3F),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description*',
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF001F3F),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: const TextStyle(fontSize: 16),
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
            const SizedBox(height: 24),
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
                const Text(
                  'Public Article',
                  style: TextStyle(fontSize: 16, color: Color(0xFF001F3F)),
                ),
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