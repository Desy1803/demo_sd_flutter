import 'package:flutter/material.dart';

class Company {
  final String name;
  final String symbol; 
  final String category;

  Company({required this.symbol, required this.name, required this.category});


  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
    );
  }
}
