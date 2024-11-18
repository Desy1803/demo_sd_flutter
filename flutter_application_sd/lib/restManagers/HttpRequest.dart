import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_sd/dtos/AnnualReport.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/dtos/AuthenticationData.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/dtos/CompanyDetails.dart';
import 'package:flutter_application_sd/dtos/Market.dart';
import 'package:flutter_application_sd/dtos/User.dart';
import 'package:flutter_application_sd/supports/Costants.dart';
import 'package:http/http.dart';
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

  Future<bool> registerUser(User u) async {
  Map<String, dynamic> params = u.toJson();
  try {
    final response = await _restManager.makePostRequest(
      Constants.ADDRESS_STORE_SERVER,
      Constants.POSTREQUEST_REGISTRATION,
      params,
      type: TypeHeader.json,
    );

    print('Raw response: $response'); // Debug per capire cosa restituisce il server

    var decodedResponse = jsonDecode(response);

    // Gestione di formati diversi
    if (decodedResponse is Map<String, dynamic>) {
      if (decodedResponse['success'] == true) {
        return true;
      } else {
        print('Registration failed with response: $decodedResponse');
        return false;
      }
    } else if (decodedResponse is bool) {
      return decodedResponse; // Caso in cui il server restituisce un booleano
    } else {
      print('Unexpected response format: $decodedResponse');
      return false;
    }
  } catch (e) {
    print('Error during user registration: $e');
    print('Params sent: $params'); // Informazioni sui parametri inviati
    return false; 
  }
}



  Future<bool?> sendVerificationEmail(String email) async{
     Map<String, dynamic> params = {
      "email": email,
    };
    try {
      final response = await _restManager.makePostRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.SEND_VERIFICATION_EMAIL,
        params,
        type: TypeHeader.json,
      );
      print('Raw response: $response');
      return jsonDecode(response) as bool?;
    } catch (e) {
      print('Error during sending email registration: $e');
      return null;
    }
    
  }
Future<bool?> isEmailVerified(String email) async{
     Map<String, dynamic> params = {
      "email": email,
    };
    print(email);
    try {
      final response = await _restManager.makePostRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.VERIFICATION_EMAIL,
        params,
        type: TypeHeader.json,
      );
      return jsonDecode(response) as bool?;
    } catch (e) {
      print('Error during user registration: $e');
      return null;
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
      print('Error loading global status market: $e');
      return null;
    }
  }

  //Articles
  Future<List<Article>?> getPublicArticles() async{
    try {
      String rawResult = await _restManager.makeGetRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.ALL_PUBLIC_ARTICLES
      );

      final parsed = json.decode(rawResult) as List<dynamic>;
  
      List<Article> res = parsed.map((item) => Article.fromJson(item)).toList();
      print("getting public articles");
      
      return res;
    } catch (e) {
      print('Error loading public articles: $e');
      return null;
    }
  }

  

}

