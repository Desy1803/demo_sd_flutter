import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/pages/CompanyDetailPage.dart';


class CompanyCategory {
  final String name;
  final IconData icon;

  CompanyCategory(this.name, this.icon);
}

class CompaniesPage extends StatefulWidget {
  @override
  _CompaniesPageState createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  List<Company> companies = [
    Company(symbol: 'IBM', name: 'IBM', category: 'Technology'),
    Company(symbol: 'MSFT', name: 'Microsoft', category: 'Technology'),
    Company(symbol: 'GS', name: 'Goldman Sachs', category: 'Finance'),
    Company(symbol: 'PFE', name: 'Pfizer', category: 'Healthcare'),
    Company(symbol: 'KO', name: 'Coca-Cola', category: 'Consumer Goods'),
    Company(symbol: 'XOM', name: 'ExxonMobil', category: 'Energy'),
    Company(symbol: 'AAPL', name: 'Apple', category: 'Technology'),
    Company(symbol: 'JPM', name: 'JP Morgan', category: 'Finance'),
    Company(symbol: 'UNH', name: 'UnitedHealth Group', category: 'Healthcare'),
    Company(symbol: 'PG', name: 'Procter & Gamble', category: 'Consumer Goods'),
    Company(symbol: 'AMZN', name: 'Amazon', category: 'Consumer Goods'),
    Company(symbol: 'FB', name: 'Facebook', category: 'Technology'),
    Company(symbol: 'TSLA', name: 'Tesla', category: 'Automotive'),
    Company(symbol: 'NFLX', name: 'Netflix', category: 'Entertainment'),
    Company(symbol: 'INTC', name: 'Intel', category: 'Technology'),
    Company(symbol: 'CVX', name: 'Chevron', category: 'Energy'),
    Company(symbol: 'WMT', name: 'Wal-Mart', category: 'Consumer Goods'),
    Company(symbol: 'BRK.B', name: 'Berkshire Hathaway', category: 'Finance'),
    Company(symbol: 'JNJ', name: 'Johnson & Johnson', category: 'Healthcare'),
    Company(symbol: 'ADBE', name: 'Adobe', category: 'Technology'),
    // Aggiungi ulteriori aziende come necessario
  ];

  List<CompanyCategory> categories = [
    CompanyCategory('Technology', Icons.computer),
    CompanyCategory('Finance', Icons.monetization_on),
    CompanyCategory('Healthcare', Icons.health_and_safety),
    CompanyCategory('Consumer Goods', Icons.shopping_cart),
    CompanyCategory('Utilities', Icons.lightbulb),
    CompanyCategory('Energy', Icons.local_fire_department),
    CompanyCategory('Automotive', Icons.directions_car),
    CompanyCategory('Entertainment', Icons.movie),
  ];

  String? hoveredCategory;

  IconData getCategoryIcon(String categoryName) {
    for (var category in categories) {
      if (category.name == categoryName) {
        return category.icon;
      }
    }
    return Icons.help; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aziende per Categoria')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categorie',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: categories.map((category) {
                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      hoveredCategory = category.name; 
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      hoveredCategory = null; 
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanySearchResultsPage(category: category.name),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100], 
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color.fromARGB(255, 109, 152, 148)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(category.icon, color: Color.fromARGB(255, 109, 152, 148)),
                          const SizedBox(width: 8),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: hoveredCategory == category.name ? Colors.grey : Colors.black, 
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Text(
              'Aziende',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(getCategoryIcon(companies[index].category), color: Color.fromARGB(255, 109, 152, 148)), // Aggiunto simbolo categoria
                    title: Text(
                      companies[index].name,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    subtitle: Text(companies[index].category),
                    trailing: Text(
                      companies[index].symbol, // Mostra il simbolo dell'azienda
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyDetailPage(company: companies[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanySearchResultsPage extends StatelessWidget {
  final String category;

  const CompanySearchResultsPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Risultati per $category')),
      body: Center(
        child: Text('Visualizza aziende per la categoria: $category'),
      ),
    );
  }
}

class CompanyDetailPage extends StatelessWidget {
  final Company company;

  const CompanyDetailPage({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(company.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${company.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Simbolo: ${company.symbol}', // Mostra il simbolo
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Categoria: ${company.category}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Dettagli aggiuntivi dell\'azienda potrebbero essere visualizzati qui.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}