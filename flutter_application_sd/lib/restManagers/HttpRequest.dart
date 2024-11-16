import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_sd/dtos/AnnualReport.dart';
import 'package:flutter_application_sd/dtos/AuthenticationData.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/dtos/CompanyDetails.dart';
import 'package:flutter_application_sd/dtos/Market.dart';
import 'package:flutter_application_sd/dtos/User.dart';
import 'package:flutter_application_sd/supports/Costants.dart';
import 'package:flutter_application_sd/supports/LoginResults.dart';

import 'RestManager.dart';

class Model {
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();

  late AuthenticationData _authenticationData;

  Future<String?> logIn(String email, String password) async {
    
      Map<String, dynamic> params = Map();
      params["username"] = email;
      params["password"] = password;
      print(params);
      try {
        await _restManager.makePostRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.POSTREQUEST_LOGIN, params,
          type: TypeHeader.json);
      }catch(e){
        print(e);
      }
      _restManager.token = _authenticationData.accessToken;
      Timer.periodic(Duration(seconds: (_authenticationData.expiresIn - 50)),
          (Timer t) {
        _refreshToken(_authenticationData.refreshToken);
      });
      return null;
    
  }

  Future<bool> _refreshToken(String refreshToken) async {
    try {
      Map<String, dynamic> params = Map();
      params["refreshToken"] = refreshToken;
      String result = await _restManager.makePostRequest(
          Constants.ADDRESS_STORE_SERVER,
          Constants.POSTREQUEST_REFRESHTOKEN,
          params,
          type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if (_authenticationData.hasError()) {
        return false;
      }
      _restManager.token = _authenticationData.accessToken;
      return true;
    } catch (e) {
      return false;
    }
  }

  void registerUser(User u) async{
    Map<String, dynamic> params = Map();
    params["user"] = u.toJson();
    try {
       await _restManager.makePostRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.POSTREQUEST_REGISTRATION, params,
          type: TypeHeader.json);
    }catch(e){
      print(e);
    }
  }


//Companies

  
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
      print("Getting companies");
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
      print("Getting companies by search");
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
      print("Getting companies details");
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
      print("getting companies report");
      
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
      print("getting global status market");
      
      return res;
    } catch (e) {
      print('Error during loading global status market: $e');
      return null;
    }
  }

  

}

