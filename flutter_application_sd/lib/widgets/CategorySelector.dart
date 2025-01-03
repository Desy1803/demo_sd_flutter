import 'package:flutter/material.dart';
import 'package:flutter_application_sd/widgets/CategorySearchWidget.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final bool isEditable;
  final bool visibleAnalysis; // Add this variable to control visibility

  CategorySelector({
    required this.selectedCategory,
    required this.onCategorySelected,
    this.isEditable = true,
    this.visibleAnalysis = true, // Set default value to true for visibility
  });

  final List<Category> _categories = [
    Category(name: 'Fundamental Data', description: 'Financial metrics that provide insight into the company\'s health.'),
    Category(name: 'Financial Data', description: 'Comprehensive financial statements for assessing a company\'s financial position.'),
    Category(name: 'Profitability & Margins', description: 'Metrics on a company\'s ability to generate profit from revenue.'),
    Category(name: 'Revenue & Growth', description: 'Indicators of a company\'s revenue growth and market expansion.'),
    Category(name: 'Analyst Ratings', description: 'Stock evaluations and recommendations from financial analysts.'),
    Category(name: 'Analysis Data', description: 'Data analysis focused on a specific year, providing insights into a company\'s performance and market trends during that period for a thorough evaluation of business dynamics.')
  ];

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

    // Filter the categories based on the visibility of "Analysis Data"
    final categoriesToShow = visibleAnalysis
        ? _categories
        : _categories.where((category) => category.name != 'Analysis Data').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Category*",
          style: labelStyle,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          items: categoriesToShow.map((category) {
            return DropdownMenuItem<String>(
              value: category.name,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: isEditable
              ? (value) {
                  if (value != null) {
                    onCategorySelected(value);
                  }
                }
              : null, 
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: "Choose a category",
            hintStyle: helperStyle,
            helperStyle: helperStyle,
          ),
          isExpanded: true,
        ),
        if (selectedCategory != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _categories.firstWhere((c) => c.name == selectedCategory).description,
              style: helperStyle,
            ),
          ),
      ],
    );
  }
}
