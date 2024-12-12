import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/ArticleResponse.dart';
import 'package:flutter_application_sd/dtos/ArticleUpdate.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class ArticleDetailedPage extends StatefulWidget {
  final ArticleResponse article;
  final bool allowEdit; // Permette la visibilità della penna
  final bool allowDelete; // Permette la visibilità del cestino

  ArticleDetailedPage({
    required this.article,
    this.allowEdit = false, // Di default non permette modifiche
    this.allowDelete = false, // Di default non permette eliminazioni
  });

  @override
  _ArticleDetailedPageState createState() => _ArticleDetailedPageState();
}

class _ArticleDetailedPageState extends State<ArticleDetailedPage> {
  bool isEditing = false;

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
        isEditing = false; 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article updated successfully!'),
          backgroundColor: Color.fromARGB(255, 197, 202, 233),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update article: $e'),
          backgroundColor: Color.fromARGB(255, 169, 13, 13),
        ),
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
        await Model.sharedInstance.deleteArticle(widget.article.id);  
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article deleted successfully!')),
        );
        Navigator.pop(context); 
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
                  FutureBuilder<Uint8List?>(
                          future: Model.sharedInstance.fetchArticleImage(widget.article.id), 
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error loading image'));
                            } else if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                );
                              } else {
                                return const Center(child: Text('No image found'));
                              }
                            } else {
                              return const Center(child: Text('No image available'));
                            }
                          },
                        ),
                  
                  const SizedBox(height: 16.0),

                  isEditing
                      ? TextField(
                          controller: titleController,
                          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(labelText: 'Title'),
                        )
                      : Text(
                          widget.article.title,
                          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(height: 8.0),

                  isEditing
                      ? TextField(
                          controller: descriptionController,
                          maxLines: 5,
                          style: const TextStyle(fontSize: 16.0, height: 1.5),
                          decoration: const InputDecoration(labelText: 'Description'),
                        )
                      : Text(
                          widget.article.description,
                          style: const TextStyle(fontSize: 16.0, height: 1.5),
                        ),
                  const SizedBox(height: 8.0),

                  isEditing
                      ? TextField(
                          controller: companyController,
                          style: const TextStyle(fontSize: 16.0),
                          decoration: const InputDecoration(labelText: 'Company'),
                        )
                      : Text(
                          widget.article.company,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                  const SizedBox(height: 8.0),

                  // Autore (non modificabile)
                  Text(
                    'Author username: ${widget.article.authorUsername }',
                    style: const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Author email: ${widget.article.authorEmail }',
                    style: const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        icon: Icons.public,
                        label: widget.article.isPublic == true ? 'Public' : 'Private',
                        color: widget.article.isPublic == true ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8.0),
                      _buildInfoChip(
                        context,
                        icon: Icons.smart_toy_outlined,
                        label: widget.article.isAi == true ? 'AI-generated' : 'Human-generated',
                        color: widget.article.isAi == true ? Colors.blue : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Pulsanti di interazione (Edit, Delete)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.allowEdit)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                        ),
                      if (widget.allowDelete)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: _deleteArticle,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  if (isEditing)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _updateArticle,
                        icon: const Icon(Icons.update),
                        label: const Text('Update Article'),
                      ),
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
}
