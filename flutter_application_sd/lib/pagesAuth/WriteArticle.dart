import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';

import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/DropZoneWidget.dart'; 
import 'dart:html' as html;

class WriteArticlePage extends StatefulWidget {
  @override
  _WriteArticlePageState createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fiscalYearController = TextEditingController();

  String imageUrl = '';  
  bool isPublic = true;  
  bool isAIEnabled = false;  
  String articleType = '';  
  String selectedCompany = '';
  String selectedFiscalYear = '';

  Future<void> saveArticle() async {
    Article article = new Article(
      id: 1, 
      title: titleController.text, 
      description: descriptionController.text, 
      company: companyController.text, 
      author: "author", 
      timeUnit: fiscalYearController.text, 
      isPublic: isPublic, 
      isAI: isAIEnabled ,
      imageUrl: imageUrl
    );
    Article? articleRet = await Model.sharedInstance.createArticle(article);
  }

  void createWithAI() {
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
                  setState(() {
                    articleType = 'FUNDAMENTAL';
                  });
                  Navigator.pop(context);
                  openCompanyYearSelection();
                },
              ),
              ListTile(
                title: Text('Create your article with Data Analysis'),
                onTap: () {
                  setState(() {
                    articleType = 'ANALYSIS';
                  });
                  Navigator.pop(context);
                  openCompanyYearSelection();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void openCompanyYearSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Company and Fiscal Year'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Company"),
                onChanged: (value) {
                  selectedCompany = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Fiscal Year"),
                onChanged: (value) {
                  selectedFiscalYear = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print('Creating article with $articleType for company $selectedCompany and fiscal year $selectedFiscalYear');
                    },
                    child: Text('Create'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write Article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: companyController,
              decoration: InputDecoration(labelText: "Company"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
              maxLines: 5,
            ),
            TextField(
              controller: fiscalYearController,
              decoration: InputDecoration(labelText: "Fiscal Year"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropZoneWidget(
              onDrop: (List<html.File>? files) {
                if (files != null && files.isNotEmpty) {
                  setState(() {
                    imageUrl = files.first.name;  // Salva il nome dell'immagine
                  });
                }
              },
            ),
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
                Text('Public Article'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: saveArticle,
                  child: Text("Save Article"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isAIEnabled = !isAIEnabled;
                    });
                    if (isAIEnabled) {
                      createWithAI();  // Chiamata per creare con AI
                    }
                  },
                  child: Text(isAIEnabled ? "Cancel AI Flow" : "Create with AI"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
