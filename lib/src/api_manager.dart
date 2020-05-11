import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'entry.dart'
    if (dart.library.io) 'impl/entry.dart'
    if (dart.library.html) 'impl/entry.html.dart';

/// Created by Taohid on 01, March, 2020
/// Email: taohid32@gmail.com
abstract class ApiManager {
  factory ApiManager({BaseOptions options}) => createApiManager(options);

  BaseOptions get options;

  void addInterceptor(Interceptor interceptor);
  void enableAuthTokenCheck(AuthTokenListener authTokenListener);
  void responseBodyWrapper(String attributeName);

  void enableLogging({
    bool request = true,
    bool requestHeader = true,
    bool requestBody = false,
    bool responseHeader = true,
    bool responseBody = false,
    bool error = true,
    Function(Object object) logPrint,
  });

  Future<MultipartFile> getMultipartFromFile(String filePath);

  Future<MultipartFile> getMultipartFromBytes(Uint8List bytes,
      [String fileName]);

  Future<ApiResponse<T>> request<T>({
    @required String route,
    @required RequestType requestType,
    Map<String, dynamic> requestParams,
    dynamic requestBody,
    CancelToken cancelToken,
    bool isAuthRequired = false,
    ResponseBodySerializer<T> responseBodySerializer,
    dynamic responseBodyWrapper,
    Options options,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
}

/// every request will wrap its response with this
/// contains api status, body data, and error message
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

/// error body of http response
class ErrorBody {
  String message;
  ErrorBody({this.message});
  factory ErrorBody.fromJson(Map<String, dynamic> jsonMap) {
    return ErrorBody(message: jsonMap['message']);
  }
}

/// enable parsing http response using this [request]
typedef M ResponseBodySerializer<M>(dynamic jsonMap);

/// enable auth token checker by pass this to [enableAuthTokenCheck]
typedef Future<String> AuthTokenListener();

/// Http request type
enum RequestType { GET, POST, PUT, DELETE }

/// Api status state
enum ApiStatus { LOADING, SUCCESS, ERROR }
