import 'package:flutter/material.dart';
import 'WriteArticle.dart'; // Importa la pagina WriteArticle

class PersonalArea extends StatelessWidget {
  // Simuliamo una lista di articoli per il momento
  final List<Map<String, String>> articles = [
    {
      'company': 'Company A',
      'year': '2023',
      'title': 'Article 1',
      'description': 'Description of Article 1',
    },
    {
      'company': 'Company B',
      'year': '2022',
      'title': 'Article 2',
      'description': 'Description of Article 2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Area"),
        backgroundColor: Color(0xFF001F3F),
      ),
      body: articles.isEmpty
          ? Center(child: Text("Create new article")) // Messaggio se non ci sono articoli
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(articles[index]['title'] ?? 'No Title'),
                  subtitle: Text(articles[index]['company'] ?? 'No Company'),
                  trailing: Text(articles[index]['year'] ?? 'No Year'),
                  onTap: () {
                    // Azione quando si clicca su un articolo
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviga verso la pagina WriteArticle
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WriteArticlePage()),
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Color(0xFF001F3F),
      ),
    );
  }
}