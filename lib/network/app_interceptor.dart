import 'package:dio/dio.dart';
import 'package:sparkduet/core/app_injector.dart';
import 'package:sparkduet/core/app_storage.dart';


class TokenInterceptor extends Interceptor {
  TokenInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{

    final localStorageProvider = sl<AppStorage>();
    String? token = await localStorageProvider.getAuthTokenVal()  ?? '';

     options.headers.addAll({"Authorization":  "Bearer $token",});

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
}
