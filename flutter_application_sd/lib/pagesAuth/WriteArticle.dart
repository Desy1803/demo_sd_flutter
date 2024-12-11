import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CategorySearchWidget.dart';
import 'package:flutter_application_sd/widgets/CompanySelector.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
import 'package:flutter_application_sd/widgets/DropZoneWidget.dart';

class WriteArticlePage extends StatefulWidget {
  @override
  _WriteArticlePageState createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fiscalYearController = TextEditingController();

  String? selectedCompany;
  String? selectedCategory;
  String? imagePreviewUrl;
  String? imageName;
  String? imageUrl; 
  bool isPublic = true;
  bool isAIEnabled = false;

  Future<void> saveArticle() async {
    if (titleController.text.isEmpty ||
        selectedCompany == null ||
        descriptionController.text.isEmpty ||
        fiscalYearController.text.isEmpty ||
        selectedCategory == null) {
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
      timeUnit: fiscalYearController.text,
      isPublic: isPublic,
      isAI: isAIEnabled,
      imageUrl: imageUrl ?? '', 
      category: selectedCategory!,
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
    try {
      final response = await Model.sharedInstance.fetchAIArticle(aiType);
      setState(() {
        titleController.text = response.title;
        descriptionController.text = response.description;
        selectedCompany = response.company;
        fiscalYearController.text = response.timeUnit;
        selectedCategory = response.category;
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
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                readOnly: isAIEnabled,
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                readOnly: isAIEnabled,
              ),
              SizedBox(height: 16),
              CompanySelector(
                selectedCompany: selectedCompany,
                onCompanySelected: (value) {
                  setState(() {
                    selectedCompany = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: fiscalYearController,
                decoration: InputDecoration(labelText: 'Fiscal Year'),
                readOnly: isAIEnabled,
              ),
              SizedBox(height: 16),
              CategorySearchWidget(onSelectedCategory: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },),
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              DropZoneWidget(
                onFilesSelected: (List<PlatformFile>? files) {
                  if (files != null && files.isNotEmpty) {
                    setState(() {
                      if (files.first.bytes != null) {
                          Uint8List? fileBytes = Uint8List.fromList(files.first.bytes!);
                          imageUrl = base64Encode(fileBytes);
                          imageName = files.first.name;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No bytes available in the selected file.')),
                          );
                        }
                      imageName = files.first.name;
                    });
                  }
                },
              ),
              const SizedBox(height: 25),
              if (imageUrl != null)
                Column(
                  children: [
                    Text(
                      "File Uploaded: ${imageName ?? "Unknown"}",
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    if (imageUrl != null)
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Image.memory(
                          base64StringToBytes(imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                )
              else
                const Text("No file selected", style: TextStyle(fontSize: 16)),
              SizedBox(height: 15 ),
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

Uint8List base64StringToBytes(String base64String) {
  try {
    return base64.decode(base64String);
  } catch (e) {
    throw FormatException("Invalid base64 string: $base64String");
  }
}

