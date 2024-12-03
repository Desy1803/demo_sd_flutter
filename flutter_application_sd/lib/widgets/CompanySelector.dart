import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';

class CompanySelector extends StatefulWidget {
  final String? selectedCompany;
  final ValueChanged<String> onCompanySelected;

  CompanySelector({this.selectedCompany, required this.onCompanySelected});

  @override
  _CompanySelectorState createState() => _CompanySelectorState();
}

class _CompanySelectorState extends State<CompanySelector> {
  List<String> allCompanies = [];
  List<String> filteredCompanies = [];
  bool isLoading = false;
  String? selectedCompany;
  TextEditingController searchController = TextEditingController();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Company>? companiesFromBackend = await Model.sharedInstance.viewCompanies();

      if (companiesFromBackend != null) {
        List<String> companyNames = companiesFromBackend
            .map((c) => c.name)
            .toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())); 
        setState(() {
          allCompanies = companyNames;
          filteredCompanies = companyNames;
        });
      } else {
        throw Exception("No companies found.");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch companies: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterCompanies(String query) {
    setState(() {
      filteredCompanies = allCompanies
          .where((company) => company.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showDropdown(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + renderBox.size.height + 5,
        width: renderBox.size.width,
        child: Material(
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search company',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _filterCompanies,
                ),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredCompanies.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('No companies found'),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            itemCount: filteredCompanies.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(filteredCompanies[index]),
                                onTap: () {
                                  setState(() {
                                    selectedCompany = filteredCompanies[index];
                                    widget.onCompanySelected(selectedCompany!);
                                  });
                                  _overlayEntry?.remove();
                                  _overlayEntry = null;
                                  searchController.clear(); 
                                  filteredCompanies=allCompanies;
                                },
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_overlayEntry != null) {
          
          setState(() {
            searchController.clear(); 
            fetchCompanies();
          });
          _hideDropdown();
        } else {
          _showDropdown(context);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedCompany ?? 'Select Company',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
