import 'package:dio/dio.dart';

import '../api_manager.dart';
import 'api_manager.dart';

/// Created by Taohid on 02, March, 2020
/// Email: taohid32@gmail.com

ApiManager createApiManager(BaseOptions _baseOptions) =>
    ApiManagerSrc(baseOptions: _baseOptions);
