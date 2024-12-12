import 'package:flutter/material.dart';
import 'package:flutter_application_sd/widgets/CategorySearchWidget.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  CategorySelector({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<Category> _categories = [
    Category(name: 'Fundamental Data', description: 'Financial metrics that provide insight into the company\'s health.'),
    Category(name: 'Financial Data', description: 'Comprehensive financial statements for assessing a company\'s financial position.'),
    Category(name: 'Annual Reports', description: 'Detailed yearly reports outlining company performance and strategy.'),
    Category(name: 'Profitability & Margins', description: 'Metrics on a company\'s ability to generate profit from revenue.'),
    Category(name: 'Revenue & Growth', description: 'Indicators of a company\'s revenue growth and market expansion.'),
    Category(name: 'Analyst Ratings', description: 'Stock evaluations and recommendations from financial analysts.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Category",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: selectedCategory,
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category.name,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onCategorySelected(value);
            }
          },
          isExpanded: true,
          hint: const Text("Choose a category"),
        ),
        if (selectedCategory != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _categories.firstWhere((c) => c.name == selectedCategory).description,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

