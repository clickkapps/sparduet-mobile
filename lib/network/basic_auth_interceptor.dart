import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BasicAuthInterceptor extends Interceptor {
  BasicAuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    options.headers.addAll({"Authorization":   getBasicAuthToken() ,});

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      response.statusCode = 200;
    }
    else if (response.statusCode == 401) {
    }
    return super.onResponse(response, handler);
  }

  String getBasicAuthToken(){

    final username = dotenv.env["BASIC_AUTH_USERNAME"];
    final password = dotenv.env["BASIC_AUTH_PASSWORD"];
    final authToken = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    return authToken;

  }
}