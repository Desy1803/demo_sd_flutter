import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompaniesPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanyBalanceSheet.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanyDetailPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/GlobalMarketStatusPage.dart';
import 'package:flutter_application_sd/pagesNotAuth/LatestInformation.dart';
import 'package:flutter_application_sd/pagesNotAuth/securityFlows/LoginPage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class CompactCompaniesPage extends StatefulWidget {
  final List<Company> companies;
  final ScrollController? scrollController;
  final TextEditingController? searchController;
  final bool isCategoryMode;
  final bool isSearchMode;
  final String? errorMessage;

  CompactCompaniesPage({
    this.companies = const [],
    this.scrollController,
    this.searchController,
    this.isCategoryMode = false,
    this.isSearchMode = false,
    this.errorMessage,
  });

  @override
  _CompactCompaniesPageState createState() => _CompactCompaniesPageState();
}

class _CompactCompaniesPageState extends State<CompactCompaniesPage> {
  late List<Company> companies;
  late List<CompanyCategory> categories;
  String? selectedCategory;
  bool isCategoryMode = false;
  String? errorMessage;

  int currentPage = 1;
  bool hasMore = true;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    companies = widget.companies;
    categories = [
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

    // Aggiungi il listener per lo scroll
    widget.scrollController?.addListener(_handleScroll);

    // Carica la prima pagina di aziende
    _loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 450;

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    _loadCompaniesByCategory(category.name);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      children: [
                        Icon(category.icon, color: Colors.black, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Companies',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const Spacer(),
                SizedBox(
                  width: isSmallScreen ? screenWidth * 0.4 : 300,
                  child: TextField(
                    controller: widget.searchController,
                    onSubmitted: (query) {
                      _loadCompaniesByCategory(query);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            errorMessage != null && companies.isEmpty
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      controller: widget.scrollController,
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              companies[index].symbol,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildStyledButton(
                                  'Latest Info',
                                  Icons.info_outline,
                                  () => _handleLatestInformation(companies[index], context),
                                ),
                                SizedBox(width: 4),
                                _buildStyledButton(
                                  'Reports',
                                  Icons.library_books,
                                  () => _handleAnnualReports(companies[index], context),
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
                  ),
          ],
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
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF001F3F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),
    );
  }

  void _handleLatestInformation(Company company, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LatestInformationPage(
          symbol: company.symbol,
          companyName: company.name,
        ),
      ),
    );
  }

  void _handleAnnualReports(Company company, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyBalanceSheet(symbol: company.symbol, companyName: company.name),
      ),
    );
  }

  // Gestisce lo scroll e carica la pagina successiva
  void _handleScroll() {
    if (widget.isSearchMode || widget.isCategoryMode) return;

    if (widget.scrollController!.position.pixels == widget.scrollController!.position.maxScrollExtent && hasMore) {
      setState(() {
        currentPage++;
      });
      _loadCompanies(isNextPage: true);
    }
  }

  // Carica le aziende dalla API con paginazione
  Future<void> _loadCompanies({bool isNextPage = false}) async {
    if (isNextPage && !hasMore) return;

    try {
      List<Company>? companiesRet = await Model.sharedInstance.viewCompanies(
        page: currentPage,
        size: pageSize,
      );

      setState(() {
        if (companiesRet != null && companiesRet.isNotEmpty) {
          if (isNextPage) {
            companies.addAll(companiesRet);
          } else {
            companies = companiesRet..sort((a, b) => a.name.compareTo(b.name));
          }
        } else if (isNextPage) {
          hasMore = false;
        } else {
          errorMessage = 'No companies found.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading companies: ${e.toString()}';
      });
      print('Error loading companies: $e');
    }
  }

  Future<void> _loadCompaniesByCategory(String category) async {
    setState(() {
      companies = [];
      errorMessage = null;
      selectedCategory = category;
      isCategoryMode = true;
      widget.searchController?.clear();
    });

    try {
      List<Company>? companiesRet = await Model.sharedInstance.getCompaniesBySearch(category);

      setState(() {
        companies = companiesRet ?? [];
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading companies by category: ${e.toString()}';
      });
    }
  }
}
