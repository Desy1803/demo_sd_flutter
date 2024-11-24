import 'dart:html' as html;
import 'package:flutter/material.dart';
class ArticleForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController companyController;
  final TextEditingController descriptionController;
  final TextEditingController fiscalYearController;
  final TextEditingController categoryController;

  final String? imagePreviewUrl;
  final ValueChanged<String>? onImageSelected;
  final bool isReadonly;

  ArticleForm({
    required this.titleController,
    required this.companyController,
    required this.descriptionController,
    required this.fiscalYearController,
    required this.categoryController,
    this.imagePreviewUrl,
    this.onImageSelected,
    this.isReadonly = false,
  });

  Future<void> selectFile(BuildContext context) async {
    if (isReadonly) return;
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) {
          final dataUrl = reader.result as String;
          final base64 = dataUrl.split(',').last;
          if (onImageSelected != null) {
            onImageSelected!(dataUrl);
          }
        });

        reader.readAsDataUrl(files.first);
      }
    });
  }

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
            readOnly: isReadonly,
          ),
          TextField(
            controller: companyController,
            decoration: InputDecoration(labelText: "Company"),
            readOnly: isReadonly,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Description"),
            maxLines: 5,
            readOnly: isReadonly,
          ),
          TextField(
            controller: fiscalYearController,
            decoration: InputDecoration(labelText: "Fiscal Year"),
            keyboardType: TextInputType.number,
            readOnly: isReadonly,
          ),
          TextField(
            controller: categoryController,
            decoration: InputDecoration(labelText: "Category"),
            readOnly: isReadonly,
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => selectFile(context),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Center(
                child: imagePreviewUrl == null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image, color: Colors.grey),
                          Text(
                            "Click here to select an image",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            imagePreviewUrl!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Text('Image selected'),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
