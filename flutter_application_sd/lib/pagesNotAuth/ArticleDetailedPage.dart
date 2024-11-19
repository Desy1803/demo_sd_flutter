import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class ArticleDetailedPage extends StatelessWidget {
  final Article article;

  ArticleDetailedPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    article.imageUrl!,
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
              // Titolo dell'articolo
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              // Descrizione dell'articolo
              Text(
                article.description,
                style: const TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16.0),
              // Dettagli aggiuntivi (Public/Private, AI-generated/Human-generated)
              Row(
                children: [
                  _buildInfoChip(
                    context,
                    icon: Icons.public,
                    label: article.isPublic == true ? 'Public' : 'Private',
                    color: article.isPublic == true ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8.0),
                  _buildInfoChip(
                    context,
                    icon: Icons.smart_toy_outlined,
                    label: article.isAI == true ? 'AI-generated' : 'Human-generated',
                    color: article.isAI == true ? Colors.blue : Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Mostra l'autore (aggiungi una proprietà dell'articolo se disponibile)
              // E.g., supponendo che `author` sia una proprietà dell'articolo
              if (article.author != null) ...[
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.person, size: 20.0, color: Colors.grey),
                    const SizedBox(width: 8.0),
                    Text(
                      'Author: ${article.author}', // Autore dell'articolo
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16.0),
              if (article.company != null) ...[
                Row(
                  children: [
                    const Icon(Icons.business, size: 20.0, color: Colors.grey),
                    const SizedBox(width: 8.0),
                    Text(
                      'Company: ${article.company}', 
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24.0),
              // Pulsanti per l'interazione (es. Condividi, Aggiungi ai preferiti)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Azione di condivisione
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                  const SizedBox(width: 16.0),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Azione di salvataggio nei preferiti
                    },
                    icon: const Icon(Icons.bookmark_border),
                    label: const Text('Bookmark'),
                  ),
                ],
              ),
            ],
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
