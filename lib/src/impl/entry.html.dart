import 'package:api_manager/api_manager.dart';
import 'package:dio/dio.dart';

import 'api_manager_impl.html.dart';

/// Created by Taohid on 02, March, 2020
/// Email: taohid32@gmail.com

ApiManager createApiManager(BaseOptions _baseOptions) =>
    ApiManagerImpl(baseOptions: _baseOptions);
