import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/Company.dart';

class CompanyDetailPage extends StatelessWidget {
  final Company company;

  const CompanyDetailPage({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${company.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Symbol: ${company.symbol}', style: TextStyle(fontSize: 18)),
            Text('Categoria: ${company.category}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
