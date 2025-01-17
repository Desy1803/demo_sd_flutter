import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanyDetailPage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class CompanySearchResultsPage extends StatefulWidget {
  final String category;

  const CompanySearchResultsPage({Key? key, required this.category}) : super(key: key);

  @override
  _CompanySearchResultsPageState createState() => _CompanySearchResultsPageState();
}

class _CompanySearchResultsPageState extends State<CompanySearchResultsPage> {
  List<Company> filteredCompanies = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCompaniesByCategory(widget.category);
  }

  Future<void> _loadCompaniesByCategory(String category) async {
    try {
      List<Company>? companiesRet = await Model.sharedInstance.getCompaniesBySearch(category);
      setState(() {
        if (companiesRet == null) {
          errorMessage = 'Error during loading companies.';
        } else {
          filteredCompanies = companiesRet;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : filteredCompanies.isEmpty
                    ? Center(child: Text('No companies found for the selected category.'))
                    : ListView.builder(
                        itemCount: filteredCompanies.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              Icons.business,
                              color: Color.fromARGB(255, 109, 152, 148),
                            ),
                            title: Text(
                              filteredCompanies[index].name,
                              style: TextStyle(decoration: TextDecoration.underline),
                            ),
                            subtitle: Text(filteredCompanies[index].category),
                            trailing: Text(
                              filteredCompanies[index].symbol,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanyDetailPage(company: filteredCompanies[index]),
                                ),
                              );
                            },
                          );
                        },
                      ),
      ),
    );
  }
}
