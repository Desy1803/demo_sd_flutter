import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/ArticleResponse.dart';
import 'package:flutter_application_sd/dtos/ArticleUpdate.dart';
import 'package:flutter_application_sd/dtos/ImageUpdate.dart';
import 'package:flutter_application_sd/pagesAuth/PersonalArea.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class ArticleDetailedPage extends StatefulWidget {
  final ArticleResponse article;
  final bool allowEdit; 
  final bool allowDelete; 

  ArticleDetailedPage({
    required this.article,
    this.allowEdit = false, 
    this.allowDelete = false, 
  });

  @override
  _ArticleDetailedPageState createState() => _ArticleDetailedPageState();
}

class _ArticleDetailedPageState extends State<ArticleDetailedPage> {
  bool isEditing = false;
  String? imagePreviewUrl;
  String? imageUrl;
  Uint8List? imageBytes;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController companyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.article.title);
    descriptionController = TextEditingController(text: widget.article.description);
    companyController = TextEditingController(text: widget.article.company);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    companyController.dispose();
    super.dispose();
  }

void _updateArticle() async {
    try {
      ArticleUpdate updatedArticle = ArticleUpdate(
        id: widget.article.id,
        title: titleController.text,
        description: descriptionController.text,
        company: companyController.text,
        author: widget.article.authorUsername!,
        isPublic: widget.article.isPublic,
        isAI: widget.article.isAi,
      );

     

      ArticleUpdate? newArticle = await Model.sharedInstance.updateArticle(updatedArticle);
      setState(() {
        widget.article.title = newArticle!.title;
        widget.article.description = newArticle.description;
        widget.article.company = newArticle.company;
        imagePreviewUrl = null; 
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article updated successfully!'),
          backgroundColor: Color(0xFF001F3F),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonalArea()),
                  );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update article: $e'),
          backgroundColor: Color.fromARGB(255, 169, 13, 13),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonalArea()),
                  );
    }
  }


 void _deleteArticle() async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This action will permanently delete the article.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    try {
      await Model.sharedInstance.deleteArticle(widget.article.id as dynamic);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article deleted successfully!')),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonalArea()),
                  );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete article: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    FutureBuilder(
                        future: Model.sharedInstance.fetchArticleImage(widget.article.id), 
                        builder: (context, snapshot) {
                          if (imagePreviewUrl != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                imagePreviewUrl!,  
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            );
                          }


                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                          if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                color: Colors.grey[200],
                                width: double.infinity,
                                height: 200,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 50.0,
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasData) {
                            final imageBytes = snapshot.data;  

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.memory(
                                imageBytes!, 
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            );
                          }


                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              color: Colors.grey[200],
                              width: double.infinity,
                              height: 200,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 50.0,
                              ),
                            ),
                          );
                        },
                      ),

                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Company
                              Row(
                                children: [
                                  const Icon(Icons.business, color: Colors.blueGrey, size: 20),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'Company: ${widget.article.company}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              // Category
                              Row(
                                children: [
                                  const Icon(Icons.category, color: Colors.teal, size: 20),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'Category: ${widget.article.category}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              // Author
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Color(0xFF001F3F), size: 20),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'Author: ${widget.article.authorUsername}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF001F3F),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 32.0, thickness: 1.0),

                      isEditing
                          ? TextField(
                              controller: titleController,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(),
                              ),
                            )
                          : Text(
                              widget.article.title,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                      const SizedBox(height: 16.0),
                      isEditing
                          ? TextField(
                              controller: descriptionController,
                              maxLines: 10,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                height: 1.5,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                            )
                          : Text(
                              widget.article.description,
                              style: const TextStyle(
                                fontSize: 16.0,
                                height: 1.5,
                                color: Colors.black54,
                              ),
                            ),
                      const SizedBox(height: 16.0),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isEditing) widget.article.isPublic = !widget.article.isPublic;
                          });
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Row(
                            key: ValueKey<bool>(widget.article.isPublic),
                            children: [
                              _buildInfoChip(
                                context,
                                icon: Icons.public,
                                label: widget.article.isPublic ? 'Public' : 'Private',
                                color: widget.article.isPublic ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8.0),
                              _buildInfoChip(
                                context,
                                icon: Icons.smart_toy_outlined,
                                label: widget.article.isAi ? 'AI-generated' : 'Human-generated',
                                color: widget.article.isAi ? Colors.blue : Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.allowEdit)
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                              },
                              icon: const Icon(Icons.edit, size: 16),
                              label: Text(isEditing ? 'Cancel Edit' : 'Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          const SizedBox(width: 8.0),
                          if (widget.allowDelete)
                            ElevatedButton.icon(
                              onPressed: _deleteArticle,
                              icon: const Icon(Icons.delete, size: 16),
                              label: const Text('Delete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Pulsante di caricamento immagine
                      if (isEditing)
                        ElevatedButton.icon(
                          onPressed: handleImageUpload,
                          icon: const Icon(Icons.upload, size: 18),
                          label: const Text('Upload Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF001F3F),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      if (isEditing)
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _updateArticle,
                            icon: const Icon(Icons.update, size: 18),
                            label: const Text('Update Article'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String label, required Color color}) {
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16.0),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
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


        _updateImage(imageUrl!); 
      }
    });
  });
}



void _updateImage(String imageUrl) async {
  try {
    ImageUpdate imageUpdate = ImageUpdate(
      id: widget.article.id,
      imageUrl: imageUrl, 
    );

    await Model.sharedInstance.updateImage(imageUpdate);

    setState(() {
      imagePreviewUrl = null; 
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to update image: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


}