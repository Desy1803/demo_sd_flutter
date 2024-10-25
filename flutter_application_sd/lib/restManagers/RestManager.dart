import 'dart:io';
import 'dart:convert';
import 'package:flutter_application_sd/supports/Costants.dart';
import 'package:flutter_application_sd/supports/ErrorListener.dart';
import 'package:http/http.dart';

enum TypeHeader { json, urlencoded }

class RestManager {
  ErrorListener? delegate;

  Future<String> _makeRequest(
    String serverAddress, String servicePath, String method, TypeHeader? type, 
    {Map<String, dynamic>? value, dynamic body}
  ) async {
    // Costruzione dell'URI
    Uri uri = Uri.http(serverAddress, servicePath, value);
    bool errorOccurred = false;
    int maxRetries = 3; 
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        var response;
        String contentType = "";
        dynamic formattedBody;

        if (type == TypeHeader.json) {
          contentType = "application/json;charset=utf-8";
          formattedBody = body != null ? json.encode(body) : null;
        } else if (type == TypeHeader.urlencoded) {
          contentType = "application/x-www-form-urlencoded";
          formattedBody = body != null ? body.keys.map((key) => "$key=${Uri.encodeComponent(body[key])}").join("&") : null;
        }

        Map<String, String> headers = {};
        if (contentType.isNotEmpty) {
          headers[HttpHeaders.contentTypeHeader] = contentType;
        }

        switch (method.toLowerCase()) {
          case "post":
            response = await post(uri, headers: headers, body: formattedBody);
            break;
          case "get":
            response = await get(uri, headers: headers);
            break;
          case "put":
            response = await put(uri, headers: headers, body: formattedBody);
            break;
          case "delete":
            response = await delete(uri, headers: headers);
            break;
          default:
            throw Exception("Metodo HTTP non supportato");
        }

        if (delegate != null && errorOccurred) {
          delegate?.errorNetworkGone();
          errorOccurred = false;
        }
        return response.body;
      } catch (err) {
        print(err);
        attempts++;
        if (delegate != null && !errorOccurred) {
          delegate?.errorNetworkOccurred(Constants.MESSAGE_CONNECTION_ERROR);
          errorOccurred = true;
        }
        await Future.delayed(const Duration(seconds: 5));
      }
    }

    throw Exception("Errore nella richiesta al server. Numero massimo di tentativi superato.");
  }

  Future<String> makePostRequest(
    String serverAddress, String servicePath, dynamic value, 
    {TypeHeader type = TypeHeader.json}
  ) async {
    return _makeRequest(serverAddress, servicePath, "post", type, body: value);
  }

  Future<String> makeGetRequest(
    String serverAddress, String servicePath, 
    [Map<String, String>? queryParams, TypeHeader? type]
  ) async {
    return _makeRequest(serverAddress, servicePath, "get", type, value: queryParams);
  }

  Future<String> makePutRequest(
    String serverAddress, String servicePath, 
    [Map<String, dynamic>? value, TypeHeader? type]
  ) async {
    return _makeRequest(serverAddress, servicePath, "put", type, value: value);
  }

  Future<String> makeDeleteRequest(
    String serverAddress, String servicePath, 
    [Map<String, String>? value, TypeHeader? type]
  ) async {
    return _makeRequest(serverAddress, servicePath, "delete", type, value: value);
  }
}
