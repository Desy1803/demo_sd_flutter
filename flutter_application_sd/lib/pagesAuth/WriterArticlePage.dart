import 'package:flutter/material.dart';

class WriterArticlePage extends StatelessWidget {
  final String symbol;
  final String category;
  final String year;

  const WriterArticlePage({
    Key? key,
    required this.symbol,
    required this.category,
    required this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Symbol: $symbol',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Category: $category',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Year: $year',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Article Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Logica per inviare l'articolo
              },
              child: Text('Submit Article'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
