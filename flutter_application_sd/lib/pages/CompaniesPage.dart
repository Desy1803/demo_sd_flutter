import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/pages/CompanyBalanceSheet.dart';
import 'package:flutter_application_sd/pages/CompanyDetailPage.dart';
import 'package:flutter_application_sd/pages/CompanySearchResultsPage.dart';
import 'package:flutter_application_sd/pages/GlobalMarketStatusPage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

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
  List<Company> companies = [];
  bool isLoading = true;
  String? errorMessage;

List<CompanyCategory> categories = [
  CompanyCategory('Technology', Icons.computer),
  CompanyCategory('Finance', Icons.monetization_on),
  CompanyCategory('Healthcare', Icons.health_and_safety),
  CompanyCategory('Consumer Discretionary', Icons.car_rental_outlined),
  CompanyCategory('Consumer Staples', Icons.apple_outlined),
  CompanyCategory('Communication Services', Icons.phone),
  CompanyCategory('Energy', Icons.local_fire_department),
  CompanyCategory('Utilities', Icons.lightbulb),
  CompanyCategory('Industrials', Icons.business_center), 
];


  String? hoveredCategory;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      List<Company>? companiesRet = await Model.sharedInstance.viewCompanies();

      setState(() {
        if (companiesRet != null) {
          companies = companiesRet..sort((a, b) => a.name.compareTo(b.name));
        } else {
          errorMessage = 'Nessuna azienda trovata.';
        }
        isLoading = false; 
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Errore nel caricamento delle aziende: ${e.toString()}';
        isLoading = false; 
      });
    }
  }

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
      appBar: CustomAppBar(
        title: 'Trading Reports',
        backgroundColor: const Color(0xFF001F3F), 
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GlobalMarketStatusPage(),
                ),
              );
            },
            icon: Icon(
              Icons.access_time, // Icona dell'orologio
              color: Colors.white, // Puoi cambiare il colore se necessario
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                    builder: (context) =>
                                        CompanySearchResultsPage(category: category.name),
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
                                        color: hoveredCategory == category.name
                                            ? Colors.grey
                                            : Colors.black,
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
                        'Companies',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: companies.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(
                                getCategoryIcon(companies[index].category),
                                color: Color.fromARGB(255, 109, 152, 148),
                              ),
                              title: Text(
                                companies[index].name,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              subtitle: Text(companies[index].category),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    companies[index].symbol,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CompanyBalanceSheet(
                                            symbol: companies[index].symbol
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.show_chart,
                                      color: Color.fromARGB(255, 109, 152, 148),
                                    ),
                                  ),
                                ],
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
