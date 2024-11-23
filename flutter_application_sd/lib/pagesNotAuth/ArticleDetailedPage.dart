import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/dtos/ArticleUpdate.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';
class ArticleDetailedPage extends StatefulWidget {
  Article article;
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
    // Disposizione dei controller per liberare risorse
    titleController.dispose();
    descriptionController.dispose();
    companyController.dispose();
    super.dispose();
  }

  void _updateArticle() async {
    try {
      // Creazione di un nuovo articolo con i dati modificati
      ArticleUpdate updatedArticle = ArticleUpdate(
        id: widget.article.id, // Manteniamo l'ID originale
        title: titleController.text,
        description: descriptionController.text,
        company: companyController.text,
        author: widget.article.author, // Manteniamo l'autore originale
        isPublic: widget.article.isPublic, // Manteniamo il flag originale
        isAI: widget.article.isAI, // Manteniamo il flag originale
        imageUrl: widget.article.imageUrl, // Manteniamo l'immagine originale
      );

      // Effettua la chiamata per aggiornare l'articolo
      ArticleUpdate? newArticle = await Model.sharedInstance.updateArticle(updatedArticle);

      // Aggiorna lo stato con l'articolo restituito dal back-end
      setState(() {
        widget.article.title = newArticle!.title;
        widget.article.description = newArticle.description;
        widget.article.company = newArticle.company;
        isEditing = false; // Disattiviamo la modalità di modifica
      });

      // Notifica di successo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article updated successfully!')),
      );
    } catch (e) {
      // Gestione errori
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update article: $e')),
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
                  // Immagine o placeholder
                  if (widget.article.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.article.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 16.0),

                  // Titolo (editable se in modalità editing)
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

                  // Descrizione (editable se in modalità editing)
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

                  // Azienda (editable se in modalità editing)
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
                    'Author: ${widget.article.author}',
                    style: const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16.0),

                  // Chips informazioni (Public/Private, AI-generated/Human-generated)
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
                        label: widget.article.isAI == true ? 'AI-generated' : 'Human-generated',
                        color: widget.article.isAI == true ? Colors.blue : Colors.orange,
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
