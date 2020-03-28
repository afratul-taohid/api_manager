import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../api_manager.dart';
import 'auth_interceptor.dart';

/// Created by Taohid on 01, March, 2020
/// Email: taohid32@gmail.com

class ApiManagerSrc implements ApiManager {
  /// http client
  Dio _dio;

  /// constructor of this class
  ApiManagerSrc({BaseOptions baseOptions}) {
    _dio = Dio(baseOptions);
    _dio.options.connectTimeout = 10000;
    _dio.options.receiveTimeout = 30000;
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
  }

  /// http success code list to check
  /// if request response success or not
  static const _successCodeList = [
    200,
    201,
    202,
    203,
    204,
    205,
    206,
    207,
    208,
    226
  ];

  @override
  BaseOptions get options {
    return _dio.options;
  }

  @override
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  @override
  void enableAuthTokenCheck(authTokenListener) {
    _dio.interceptors.add(
      AuthInterceptor(authTokenListener),
    );
  }

  @override
  void enableLogging({
    bool request = true,
    bool requestHeader = true,
    bool requestBody = false,
    bool responseHeader = true,
    bool responseBody = false,
    bool error = true,
    Function(Object object) logPrint = print,
  }) {
    _dio.interceptors.add(
      LogInterceptor(
          request: request,
          requestHeader: requestHeader,
          requestBody: requestBody,
          responseHeader: responseHeader,
          responseBody: responseBody,
          error: error,
          logPrint: logPrint),
    );
  }

  @override
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
  }) async {
    /// check internet connectivity & return an internet error message
    if (!await ConnectivityManager.isConnected()) {
      return _internetError<T>();
    }

    if (options == null) {
      options = Options();
    }
    options = Options(headers: {"isauthrequired": isAuthRequired});

    try {
      switch (requestType) {

        /// http get request method
        case RequestType.GET:
          final response = await _dio.get(
            route,
            queryParameters: params,
            cancelToken: cancelToken,
            options: options,
            onReceiveProgress: onReceiveProgress,
          );
          return _returnResponse<T>(response, bodyParser);

        /// http post request method
        case RequestType.POST:
          final response = await _dio.post(
            route,
            data: body,
            queryParameters: params,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          return _returnResponse<T>(response, bodyParser);

        /// http put request method
        case RequestType.PUT:
          final response = await _dio.put(
            route,
            data: body,
            queryParameters: params,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          return _returnResponse<T>(response, bodyParser);

        /// http delete request method
        case RequestType.DELETE:
          final response = await _dio.delete(
            route,
            data: body,
            queryParameters: params,
            cancelToken: cancelToken,
            options: options,
          );
          return _returnResponse<T>(response, bodyParser);

        /// throw an exception when no http request method is passed
        default:
          throw Exception('No request type passed');
      }
    } on DioError catch (error) {
      return ApiResponse.error(
        error.response == null
            ? error.message
            : error.response?.data['message'],
      );
    }
  }

  /// check the response success status
  /// then wrap the response with api call
  /// return {ApiResponse}
  ApiResponse<T> _returnResponse<T>(
    Response response,
    BodyParser<T> bodyParser,
  ) {
    if (_successCodeList.contains(response.statusCode)) {
      try {
        if (bodyParser == null) {
          return ApiResponse.completed(response.data);
        } else {
          return ApiResponse.completed(bodyParser(response.data));
        }
      } catch (e) {
        return ApiResponse.error("Data Parsing Error");
      }
    } else {
      return ApiResponse.error(response.statusMessage);
    }
  }

  ApiResponse<T> _internetError<T>() {
    return ApiResponse.error("Internet not connected");
  }
}
