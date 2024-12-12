import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanyBalanceSheet.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanyDetailPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanySearchResultsPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/GlobalMarketStatusPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/LatestInformation.dart';
import 'package:flutter_application_sd/pagesNotAuth/securityFlows/LoginPage.dart'; 
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
        if (companiesRet != null && companiesRet.isNotEmpty) {
          companies = companiesRet..sort((a, b) => a.name.compareTo(b.name));
        } else {
          errorMessage = 'No companies found.';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading companies: ${e.toString()}';
        isLoading = false;
      });
      print('Error loading companies: $e');
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
        showBackButton: false,
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
              Icons.access_time,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.black, fontSize: 18)))
                : SingleChildScrollView(
                    child: Column(
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
                                      builder: (context) => CompanySearchResultsPage(category: category.name),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: hoveredCategory == category.name
                                        ? Colors.grey.withOpacity(0.3)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(category.icon, color: Colors.black),
                                      const SizedBox(width: 8),
                                      Text(
                                        category.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
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
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: companies.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  getCategoryIcon(companies[index].category),
                                  color: Colors.black,
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      companies[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '(${companies[index].symbol})',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  companies[index].category,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildStyledButton(
                                      'Latest Information',
                                      Icons.info_outline,
                                      () => _handleLatestInformation(companies[index]),
                                    ),
                                    SizedBox(width: 8),
                                    _buildStyledButton(
                                      'Annual Reports',
                                      Icons.library_books,
                                      () => _handleAnnualReports(companies[index]),
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
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildStyledButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF001F3F), // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }

  void _handleLatestInformation(Company company) {
    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LatestInformationPage(symbol: company.symbol, companyName: company.name,), 
                ),
              );
  }

  void _handleAnnualReports(Company company) {
       Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyBalanceSheet(symbol: company.symbol), 
                ),
              );
  }
}