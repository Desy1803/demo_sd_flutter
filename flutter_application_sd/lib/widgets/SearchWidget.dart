import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart'; // Aggiungi il manager per le chiamate HTTP

class SearchWidget extends StatefulWidget {
  final String searchType; // 'Companies' o 'Articles'
  final String visibility; // 'public' o 'private'
  final double height; 
  final double width;  // Parametro per la gestione della larghezza del widget

  // Inizializza i parametri
  SearchWidget({required this.searchType, required this.visibility, this.height = 20, this.width = double.infinity});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  Future<void> _performSearch(String query) async {
    bool isPublic = widget.visibility == 'public'; 
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.searchType == 'Companies') {
        final results = await _searchCompanies(query);
        setState(() {
          _searchResults = results!;
        });
      }
      else if (widget.searchType == 'Articles') {
        final results = await _searchArticles(query, isPublic);
        setState(() {
          _searchResults = results!;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List?> _searchCompanies(String query) async {
    final response = await Model.sharedInstance.getCompaniesBySearch(query);
    return response; 
  }

  // Funzione per la ricerca degli articoli
  Future<List?> _searchArticles(String query, bool isPublic) async {
    List<dynamic>? response;
    // Se 'public', cerca gli articoli pubblici, altrimenti cerca quelli privati
    if (isPublic) {
      response = await Model.sharedInstance.getPublicArticles(); //TODO Funzione da implementare per articoli pubblici
    } else {
      response = await Model.sharedInstance.getPublicArticles(); //TODO Funzione da implementare per articoli privati
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2),
          height: widget.height, 
          width: widget.width,   // Imposta la larghezza personalizzata
          child: TextField(
            controller: _searchController,
            style: TextStyle(fontSize: 14), 
            decoration: InputDecoration(
              labelText: 'Search ${widget.searchType}',
              labelStyle: TextStyle(fontSize: 14), // Riduci la dimensione del label
              prefixIcon: Icon(Icons.search, size: 20), // Riduci la dimensione dell'icona
              suffixIcon: _isLoading
                  ? CircularProgressIndicator()
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Riduci l'altezza
            ),
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                _performSearch(query); // Chiamata alla ricerca
              }
            },
          ),
        ),
        
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
