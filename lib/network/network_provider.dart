import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sparkduet/network/api_error.dart';
import 'package:sparkduet/network/app_interceptor.dart';
import 'package:sparkduet/network/basic_auth_interceptor.dart';


class NetworkProvider {

   Dio _getDioInstance({required bool useToken}) {
    var dio = Dio(BaseOptions(
      connectTimeout: const Duration(minutes: 5),
      receiveTimeout: const Duration(minutes: 5),
    ));
    if (useToken) {
      dio.interceptors.add(TokenInterceptor());
    } else {
      dio.interceptors.add(BasicAuthInterceptor());
    }
    dio.interceptors.add(LogInterceptor(
        responseBody: true, error: true, request: true, requestBody: true));

    return dio;
  }

  Future<Response?> call(
      {required String path,
      required RequestMethod method,
      bool useToken = true,
      dynamic body = const {},
      Map<String, dynamic> queryParams = const {},
      FormData? formData,
        Function(int, int )? onUploadProgress
      }) async {
    Response? response;
    try {
      switch (method) {
        case RequestMethod.get:
          response = await _getDioInstance(useToken: useToken).get(
            path,
            queryParameters: queryParams,
          );
          break;
        case RequestMethod.post:
          response = await _getDioInstance(useToken: useToken)
              .post(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.patch:
          response = await _getDioInstance(useToken: useToken)
              .patch(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.put:
          response = await _getDioInstance(useToken: useToken)
              .put(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.delete:
          response = await _getDioInstance(useToken: useToken)
              .delete(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.upload:
          response = await _getDioInstance(useToken: useToken).post(
            path,
            data: formData,
            onSendProgress: (int sent, int total) {
              // BlocProvider.of(context)
              //  if(proShotsScaffold.currentContext != null){
              //    BlocProvider.of<ProgressCubit>(proShotsScaffold.currentContext!).checkUploadProgress(total: total,sent: sent);
              //  }
              if (kDebugMode) {
                print('$sent $total');
              }
              onUploadProgress?.call(sent, total);
            },
          );
          break;
        case RequestMethod.uploadWithPut:
          response = await _getDioInstance(useToken: useToken).put(
            path,
            data: formData,
            onSendProgress: (int sent, int total) {
              if (kDebugMode) {
                print('$sent $total');
              }
              onUploadProgress?.call(sent, total);
            },
          );
          break;
      }

      return response;
    } on DioException catch (e) {
      if(e.response?.data is Map<String, dynamic>){
        return e.response;
      }
      return Future.error(ApiError.fromDio(e));
    }
  }

  Future<Response?> upload({
    required String path,
    dynamic body = const {},
  }) async {
    Response? response;

    try {
      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(minutes: 3),
        receiveTimeout: const Duration(minutes: 3),
      ));
      dio.interceptors.add(LogInterceptor(
          responseBody: true, error: true, request: true, requestBody: true));

      dio.options.headers.addAll({});

      response = await dio.post(
        path,
        data: body,
      );
    } on DioException catch (e) {
      return Future.error(ApiError.fromDio(e));
    }

    return response;
  }
}

enum RequestMethod { get, post, put, patch, delete, upload, uploadWithPut }
