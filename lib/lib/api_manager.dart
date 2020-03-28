import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'entry.dart' if (dart.library.io) '../src/entry.dart';

/// Created by Taohid on 01, March, 2020
/// Email: taohid32@gmail.com

typedef M BodyParser<M>(Map<String, dynamic> jsonMap);

typedef Future<String> AuthTokenListener();

enum RequestType { GET, POST, PUT, DELETE }

enum ApiStatus { LOADING, SUCCESS, ERROR }

abstract class ApiManager {
  factory ApiManager({BaseOptions options}) => createApiManager(options);

  BaseOptions get options;

  void addInterceptor(
    Interceptor interceptor,
  );

  void enableAuthTokenCheck(
    AuthTokenListener authTokenListener,
  );

  void enableLogging({
    bool request = true,
    bool requestHeader = true,
    bool requestBody = false,
    bool responseHeader = true,
    bool responseBody = false,
    bool error = true,
    Function(Object object) logPrint,
  });

  Future<ApiResponse<T>> request<T>({
    @required String route,
    @required RequestType requestType,
    BodyParser<T> bodyParser,
    Map<String, dynamic> params,
    Map<String, dynamic> body,
    CancelToken cancelToken,
    bool isAuthRequired = false,
    Options options,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
}

class ApiResponse<T> {
  ApiStatus status;
  T data;
  String errorMessage;

  ApiResponse.loading() : status = ApiStatus.LOADING;
  ApiResponse.completed(this.data) : status = ApiStatus.SUCCESS;
  ApiResponse.error(this.errorMessage) : status = ApiStatus.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $errorMessage \n Data : $data";
  }
}

class ErrorBody {
  String message;
  ErrorBody({this.message});
  factory ErrorBody.fromJson(Map<String, dynamic> jsonMap) {
    return ErrorBody(message: jsonMap['message']);
  }
}
