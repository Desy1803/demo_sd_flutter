import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_application_sd/dtos/AnnualReport.dart';
import 'package:flutter_application_sd/dtos/Article.dart';
import 'package:flutter_application_sd/dtos/ArticleResponse.dart';
import 'package:flutter_application_sd/dtos/ArticleUpdate.dart';
import 'package:flutter_application_sd/dtos/AuthenticationData.dart';
import 'package:flutter_application_sd/dtos/Company.dart';
import 'package:flutter_application_sd/dtos/CompanyDetails.dart';
import 'package:flutter_application_sd/dtos/LatestInfoDto.dart';
import 'package:flutter_application_sd/dtos/Market.dart';
import 'package:flutter_application_sd/dtos/SearchArticleCriteria.dart';
import 'package:flutter_application_sd/dtos/User.dart';
import 'package:flutter_application_sd/supports/Costants.dart';
import 'RestManager.dart';

class Model {
  static final Model sharedInstance = Model();

  RestManager _restManager = RestManager();

  late AuthenticationData? _authenticationData = null;




  Future<String?> logIn(String email, String password) async {
    Map<String, dynamic> params = {
      "username": email,
      "password": password,
    };

    try {
      String response = await _restManager.makePostRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.POSTREQUEST_LOGIN,
        params,
        false,
        type: TypeHeader.json,
      );


      _authenticationData = AuthenticationData.fromJson(jsonDecode(response));

      if (_authenticationData!.hasError()) {
        return _authenticationData!.accessToken ?? null;
      }

      _restManager.token = _authenticationData!.accessToken;

      Timer.periodic(
        Duration(seconds: (_authenticationData!.expiresIn - 50)),
        (Timer t) {
          _refreshToken(_authenticationData!.refreshToken);
        },
      );

      return _authenticationData!.accessToken; 
    } catch (e) {
      print("Login error: $e");
      return "An error occurred during login: $e";
    }
  }
   bool isAuthenticated(){
    
      if (_authenticationData==null ||_authenticationData!.accessToken.isEmpty || _authenticationData!.accessToken==""){
        return false;
      }
      return true;
  }

  Future<bool> _refreshToken(String refreshToken) async {
    Map<String, dynamic> params = {"refreshToken": refreshToken};

    try {
      String response = await _restManager.makePostRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.POSTREQUEST_REFRESHTOKEN,
        params,
        false,
        type: TypeHeader.urlencoded,
      );


      _authenticationData = AuthenticationData.fromJson(jsonDecode(response));

      if (_authenticationData!.hasError()) {
        print("Error in refreshed token: ${_authenticationData}");
        return false;
      }

      _restManager.token = _authenticationData!.accessToken;

      return true;
    } catch (e) {
      print("Refresh token error: $e");
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
      false,
      type: TypeHeader.json,
    );


    var decodedResponse = jsonDecode(response);


    if (decodedResponse is Map<String, dynamic>) {
      if (decodedResponse['success'] == true) {
        return true;
      } else {
        print('Registration failed with response: $decodedResponse');
        return false;
      }
    } else if (decodedResponse is bool) {
      return decodedResponse; 
    } else {
      print('Unexpected response format: $decodedResponse');
      return false;
    }
  } catch (e) {
    print('Error during user registration: $e');
    print('Params sent: $params'); 
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
        false,
        type: TypeHeader.json,
      );
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
    try {
      final response = await _restManager.makePostRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.VERIFICATION_EMAIL,
        params,
        false,
        type: TypeHeader.json,
      );
      return jsonDecode(response) as bool?;
    } catch (e) {
      print('Error during user registration: $e');
      return null;
    }
    
  }
Future<bool?> sendPasswordReset(String email) async{
     Map<String, dynamic> params = {
      "email": email,
    };
    try {
      final response = await _restManager.makePostRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.PASSWORD_RESET,
        params,
        false,
        type: TypeHeader.json,
      );
      return jsonDecode(response) as bool?;
    } catch (e) {
      print('Error during reset password: $e');
      return null;
    }
    
  }

//Companies

  
  Future<List<Company>?>  viewCompanies() async {
    try {
      String rawResult = await _restManager.makeGetRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.GETREQUEST_VIEWALLCOMPANIES,
        false
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
        false,
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
        false,
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

  Future<LatestInfoDto?> getLatestInfo(String symbol) async {
    try {
      String rawResult = await _restManager.makeGetRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.GET_REQUEST_GETLATESTINFO,
        false,
        {
          'symbol': symbol,      
        },
      );

      LatestInfoDto res = LatestInfoDto.fromJson(json.decode(rawResult));
      print("Getting latest info company ${res}" );
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
        false,
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
        false,
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
  
Future<List<ArticleResponse>?> getPublicArticles({required SearchArticleCriteria criteria}) async {
  try {
    final String endpoint = Constants.ALL_PUBLIC_ARTICLES;
    
    final Map<String, dynamic> filters = criteria.toJson();


    final String rawResult = await _restManager.makeGetRequest(
      Constants.ADDRESS_STORE_SERVER,
      endpoint,
      false,
      filters, 
    );

    if (rawResult.isEmpty) {
      throw Exception("Empty response from server for public articles.");
    }
    final dynamic parsed = json.decode(rawResult);

    if (parsed is List) {
      List<ArticleResponse> articles = parsed.map((item) => ArticleResponse.fromJson(item)).toList();
      
      print("Loaded ${articles.length} public articles.");
      return articles;
    }else {
      print("Error: Expected a list of articles, but got: $parsed");
      return [];
    }
  } catch (e, stacktrace) {
    print('Error loading public articles: $e');
    print('Stacktrace: $stacktrace');
    return [];
  }
}

Future<List<ArticleResponse>> getUserArticles({required SearchArticleCriteria criteria}) async {
  try {
    final String endpoint = Constants.GETREQUEST_GETARTICLEBYUSER;
    
    final Map<String, dynamic> filters = criteria.toJson();

    final String rawResult = await _restManager.makeGetRequest(
      Constants.ADDRESS_STORE_SERVER,
      endpoint,
      true,
      filters, 
    );

    if (rawResult.isEmpty) {
      throw Exception("Empty response from server for user articles.");
    }

    final List<dynamic> parsed = json.decode(rawResult);
    final List<ArticleResponse> articles = parsed.map((item) => ArticleResponse.fromJson(item)).toList();

    print("Loaded ${articles.length} user articles.");
    return articles;
  } catch (e, stacktrace) {
    print('Error loading user articles: $e');
    print('Stacktrace: $stacktrace');
    return [];
  }
}




  Future<Article?> createArticle(Article article) async{
    try {
      Map<String, dynamic> params = article.toJson();

      String rawResult = await _restManager.makePostRequest(
        Constants.ADDRESS_STORE_SERVER,
        Constants.CREATE_ARTICLE_AUTH, 
        params,
        true
      );

      final parsed = json.decode(rawResult) as Map<String, dynamic>;
  
      Article res = Article.fromJson(parsed );
      print("create article");
      
      return res;
    } catch (e) {
      print('Error loading public articles: $e');
      return null;
    }
  }

  
Future<ArticleUpdate?> updateArticle(ArticleUpdate article) async {
  try {

    Map<String, dynamic> params = article.toJson();
    String rawResult = await _restManager.makePutRequest(
      Constants.ADDRESS_STORE_SERVER, 
      Constants.UPDATE_ARTICLE_AUTH, 
      true,
      params
    );
    print("Raw ${rawResult}");
    final parsed = json.decode(rawResult) as Map<String, dynamic>;

    ArticleUpdate res = ArticleUpdate.fromJson(parsed);
    print("Update article");

    return res;
  } catch (e) {
    print('Error updating article: $e');
    return null;
  }
}



Future<void> deleteArticle(int articleId) async {
  try {
    Map<String, int> params = {
      "id": articleId,
    };
    String endpoint = "${Constants.DELETE_ARTICLE_AUTH}";

    String rawResult = await _restManager.makeDeleteRequest(
      Constants.ADDRESS_STORE_SERVER, 
      endpoint, 
      true,
      params
    );

    final parsed = json.decode(rawResult) as Map<String, dynamic>;

    print("Delete article");

  } catch (e) {
    print('Error deleting article: $e');
  }
}

  Future<ArticleResponse> fetchAIArticle( {required String? company, required String? category, required DateTime? date, required String? useGoogle}) async {
     dynamic params = {
      "company": company!,
      "category": category!,
      "date": date.toString(),
      "getSourcesFromGoogle": useGoogle
     };
    String endpoint = "${Constants.POSTREQUEST_CREATEARTICLEWITHAI}";

    String rawResult = await _restManager.makePostRequest(
      Constants.ADDRESS_STORE_SERVER, 
      endpoint, 
      params,
      true
    );

    final parsed = json.decode(rawResult) as Map<String, dynamic>;
    return ArticleResponse.fromJson(parsed);
  }

  Future<Uint8List?> fetchArticleImage(int articleId) async {
  try {
    String endpoint = "${Constants.GETIMAGE_ARTICLE}";
   
    Map<String, dynamic> queryParams = {
      'articleId': articleId.toString(),  
    };
    String rawResult = await _restManager.makeGetRequest(
      Constants.ADDRESS_STORE_SERVER, 
      endpoint, 
      false,
      queryParams 
    );
    
    
    final parsed = base64.decode(rawResult);
    
    return Uint8List.fromList(parsed);

  } catch (e) {
    print('Error image article: $e');
    return null;  
  }
}

  
}