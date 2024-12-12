import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pagesAuth/GeneratedArticlePage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CompanySelector.dart';
import 'package:flutter_application_sd/widgets/CategorySelector.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
import 'package:flutter_application_sd/widgets/DateSelectort.dart';
import 'dart:html' as html;

class CreateArticleWithAIWidget extends StatefulWidget {
  @override
  _CreateArticleWithAIWidgetState createState() => _CreateArticleWithAIWidgetState();
}

class _CreateArticleWithAIWidgetState extends State<CreateArticleWithAIWidget> {
  String? selectedCompany;
  String? selectedCategory;
  DateTime? selectedDate;
  bool useGoogle = false;
  String? imagePreviewUrl;
  String imageUrl = '';

  Future<void> createArticleWithAI() async {
    if (selectedCompany == null || selectedCategory == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all required fields.')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final response = await Model.sharedInstance.fetchAIArticle(
        company: selectedCompany!,
        category: selectedCategory!,
        date: selectedDate!,
        useGoogle: useGoogle.toString(),
      );

      Navigator.pop(context); 
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GeneratedArticlePage(article: response),
        ),
      );
    } catch (e) {
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create article: $e')),
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
                'Write Your Article With AI',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001F3F),
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
              ),
              const SizedBox(height: 16),
              DateSelector(
                selectedDate: selectedDate,
                onDateSelected: (value) {
                  setState(() {
                    selectedDate = value;
                  });
                },
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
                    value: useGoogle,
                    onChanged: (value) {
                      setState(() {
                        useGoogle = value!;
                      });
                    },
                  ),
                  const Text('Allow AI to use Google'),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: createArticleWithAI,
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
                    "Create Article",
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
