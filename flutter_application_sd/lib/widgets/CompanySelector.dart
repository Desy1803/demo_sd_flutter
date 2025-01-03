import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';

class CompanySelector extends StatefulWidget {
  final String? selectedCompany;
  final ValueChanged<String> onCompanySelected;
  final bool isEditable;

  const CompanySelector({
    this.selectedCompany,
    required this.onCompanySelected,
    this.isEditable = true,
  });

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
    selectedCompany = widget.selectedCompany;
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Company>? companiesFromBackend = await Model.sharedInstance.viewCompanies(page: -1, size: -1);

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
              if (widget.isEditable)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search company',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterCompanies,
                  ),
                ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredCompanies.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No companies found'),
                        )
                      : ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
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
                                  filteredCompanies = allCompanies;
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
    final labelStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF001F3F),
    );

    final helperStyle = const TextStyle(
      fontSize: 14,
      color: Colors.grey,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Company*",
          style: labelStyle,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (!widget.isEditable) return;

            if (_overlayEntry != null) {
              _hideDropdown();
            } else {
              _showDropdown(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCompany ?? 'Choose a company',
                  style: TextStyle(color: selectedCompany != null ? Colors.black : Colors.grey[600]),
                ),
                if (widget.isEditable) const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Choose a company from the list or search by name.",
          style: helperStyle,
        ),
      ],
    );
  }
}
