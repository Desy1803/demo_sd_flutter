
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanyDetailPage.dart';

class CompanySearchDelegate extends SearchDelegate {
  final List<Company> companies;

  CompanySearchDelegate(this.companies);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = companies.where((company) => company.name.toLowerCase().contains(query.toLowerCase()));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final company = results.elementAt(index);
        return ListTile(
          title: Text(
            company.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, 
            ),
          ),
          subtitle: Text('Category: ${company.category}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyDetailPage(company: company),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = companies.where((company) => company.name.toLowerCase().startsWith(query.toLowerCase()));

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final company = suggestions.elementAt(index);
        return ListTile(
          title: Text(
            company.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, 
            ),
          ),
          subtitle: Text('Categoria: ${company.category}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyDetailPage(company: company),
              ),
            );
          },
        );
      },
    );
  }
}