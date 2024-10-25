import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_sd/dtos/AnnualReport.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/dtos/CompanyDetails.dart';
import 'package:flutter_application_sd/dtos/Market.dart';
import 'package:flutter_application_sd/supports/Costants.dart';

import 'RestManager.dart';

class Model {
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();


//Companies

  
//view list of fornitori
  Future<List<Company>?>  viewCompanies() async {
    try {
      String rawResult = await _restManager.makeGetRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.GETREQUEST_VIEWALLCOMPANIES,
      );
      List<Company> res = List<Company>.from(json
          .decode(rawResult)
          .map((i) => Company.fromJson(i))
          .toList());
      print(res);
      return res;
    } catch (e) {
      return null;
    }
  }



  Future<List<Company>?> getCompaniesBySearch(String value) async {
    try {
      String rawResult = await _restManager.makeGetRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.GETREQUEST_GETCOMPANIESBYSEARCH,
        {'query': value}, 
      );

      List<Company> res = List<Company>.from(
        json.decode(rawResult).map((i) => Company.fromJson(i)).toList(),
      );
      print(res);
      return res;
    } catch (e) {
      return null;
    }
  }
  Future<CompanyDetails?> getCompanyDetails(String symbol) async {
    try {
      String rawResult = await _restManager.makeGetRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.GETREQUEST_GETCOMPANYFUNDAMENTALDATA,
        {
          'function': 'OVERVIEW', 
          'symbol': symbol,      
        },
      );

      CompanyDetails res = CompanyDetails.fromJson(json.decode(rawResult));
      print(res);
      return res;
    } catch (e) {
      print('Errore durante il recupero dei dettagli dell\'azienda: $e');
      return null;
    }
  }

  Future<List<AnnualReport>?> getCompaniesReport(String value) async {
    try {
      String rawResult = await _restManager.makeGetRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.GETREQUEST_GETCOMPANYBALANCESHEET,
        {'symbol': value}, 
      );

      
      final parsed = json.decode(rawResult);
      final marketsList = parsed['annualReports'] as List<dynamic>;
      List<AnnualReport> res = marketsList.map((i) => AnnualReport.fromJson(i)).toList();
      print(res);
      
      return res;
    } catch (e) {
      return null;
    }
  }
  Future<List<Market>?> getGlobalStatusMarket() async {
    try {
      String rawResult = await _restManager.makeGetRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.GETREQUEST_GETGLOBALMARKETSTATUS,
        {'function': "MARKET_STATUS"},
      );

      final parsed = json.decode(rawResult);
      final marketsList = parsed['markets'] as List<dynamic>;
      List<Market> res = marketsList.map((i) => Market.fromJson(i)).toList();
      print(res);
      
      return res;
    } catch (e) {
      print('Errore nel caricamento dei mercati: $e');
      return null;
    }
  }

  

}


