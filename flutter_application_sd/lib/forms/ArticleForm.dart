import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_application_sd/widgets/DropZoneWidget.dart';

class ArticleForm extends StatefulWidget {
  final Function(String, String, String, String) onSave;

  const ArticleForm({required this.onSave});

  @override
  _ArticleFormState createState() => _ArticleFormState();
}

class _ArticleFormState extends State<ArticleForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fiscalYearController = TextEditingController();

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          DropZoneWidget(
            onDrop: (List<File>? files) {
              // Gestisci il file dropped
              if (files != null && files.isNotEmpty) {
                setState(() {
                  imageUrl = files.first.name; 
                });
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.onSave(
                    titleController.text,
                    companyController.text,
                    descriptionController.text,
                    fiscalYearController.text,
                  );
                },
                child: Text("Save"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Gestire il salvataggio con AI
                  print("Creating article with AI");
                },
                child: Text("Create with AI"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
