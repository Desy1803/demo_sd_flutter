import 'package:flutter/material.dart';

class Company {
  final String name;
  final String symbol; // Nuovo campo per il simbolo
  final String category;

  // Utilizzare il costruttore con argomenti nominati
  Company({required this.symbol, required this.name, required this.category});
}