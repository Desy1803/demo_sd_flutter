import 'dart:async';
import 'package:flutter/material.dart';

// Define the Category model
class Category {
  final String name;
  final String description;

  Category({required this.name, required this.description});
}

class CategorySearchWidget extends StatefulWidget {
  final Function(String?) onSelectedCategory;

  CategorySearchWidget({required this.onSelectedCategory});

  @override
  _CategorySearchWidgetState createState() => _CategorySearchWidgetState();
}

class _CategorySearchWidgetState extends State<CategorySearchWidget> {
  final List<Category> _categories = [
    Category(name: 'Fundamental Data', description: 'Financial metrics that provide insight into the company\'s health.'),
    Category(name: 'Financial Data', description: 'Comprehensive financial statements for assessing a company\'s financial position.'),
    Category(name: 'Annual Reports', description: 'Detailed yearly reports outlining company performance and strategy.'),
    Category(name: 'Profitability & Margins', description: 'Metrics on a company\'s ability to generate profit from revenue.'),
    Category(name: 'Revenue & Growth', description: 'Indicators of a company\'s revenue growth and market expansion.'),
    Category(name: 'Analyst Ratings', description: 'Stock evaluations and recommendations from financial analysts.'),
  ];

  String? _selectedCategoryName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Show the dropdown menu when clicked
        final String? selectedCategory = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text('Select a category'),
              children: _categories.map((category) {
                return SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, category.name);
                  },
                  child: Text(category.name),
                );
              }).toList(),
            );
          },
        );

        // Handle the selected category
        if (selectedCategory != null) {
          setState(() {
            _selectedCategoryName = selectedCategory;
          });
          widget.onSelectedCategory(selectedCategory);
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
              _selectedCategoryName ?? 'Select a category',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
