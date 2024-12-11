import 'package:flutter_application_sd/dtos/StockDetailsDto.dart';

class AiRequest {
  String? company;
  String? category;
  StockDetailsDTO? dataOfCompany;
  bool? getSourcesFromGoogle;

  AiRequest({required this.company, required this.category, this.dataOfCompany, required this.getSourcesFromGoogle});

  factory AiRequest.fromJson(Map<String, dynamic> json) {
    return AiRequest(
      company: json['company'],
      category: json['category'],
      dataOfCompany: json['dataOfCompany'],
      getSourcesFromGoogle: json['getSourcesFromGoogle']
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'category': category,
      'dataOfCompany': dataOfCompany,
      'getSourcesFromGoogle': getSourcesFromGoogle
    };
  }
}