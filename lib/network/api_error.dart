import 'package:dio/dio.dart';

class ApiError {

  late String errorDescription;

  ApiError({required this.errorDescription});

  ApiError.fromDio(Object dioError) {
    _handleError(dioError);
  }

  void _handleError(Object error) {
    if (error is DioException) {
      var dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = "Request was cancelled";
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = "Connection timeout";
          break;
        case DioExceptionType.badResponse:
          errorDescription = error.message ?? "Unable to connect";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = "Connection timeout";
          break;
        case DioExceptionType.unknown:
          if (dioError.response!.statusCode == 401) {
            errorDescription = 'Session timeout';
          }
          else if (dioError.response!.statusCode == 400 || dioError.response!.statusCode! <= 409) {
            errorDescription = extractDescriptionFromResponse(error.response);
          } else if (dioError.response!.statusCode == 500) {
            errorDescription = 'A Server Error Occurred';
          } else {
            errorDescription =
                'Something went wrong, please check your internet connection..';
          }
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = "Send timeout in connection";
          break;
        case DioExceptionType.badCertificate:
          errorDescription = "Bad Certificate";
          break;

        case DioExceptionType.connectionError:
          errorDescription = "Unable to connect";
          break;
      }
    } else {
      errorDescription = "An unexpected error occurred";
    }
  }

  String extractDescriptionFromResponse(Response? response) {
    var message = '';

    var decodeResponse = response!.data;
    try {
      if (response.data != null) {
        if (decodeResponse is String) {
          message = decodeResponse;
        } else {
          message = decodeResponse['error'];
        }
      } else {
        message = response.statusMessage!;
      }
    } catch (error) {
      message = response.statusMessage ?? error.toString();
    }
    return message;
  }

  @override
  String toString() => errorDescription;
}
