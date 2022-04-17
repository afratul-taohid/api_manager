# api_manager [![pub package](https://img.shields.io/pub/v/api_manager?style=social)](https://pub.dev/packages/api_manager)

A simple flutter API to manage rest api request easily with the help of flutter dio. 

## Get started

## Install

### Add dependency

[![pub package](https://img.shields.io/pub/v/api_manager?style=for-the-badge)](https://pub.dev/packages/api_manager)

```yaml
dependencies:
  api_manager: $latest_version
```

### Super simple to use

```dart
import 'package:api_manager/api_manager.dart';

void main() async {
 
  ApiResponse response = await ApiManager().request(
    requestType: RequestType.GET,
    route: "your route",
  );
  print(response);
}
```

### Config in a base manager
```dart

class ApiRepository {
  static const BASE_URL = 'https://google.com/api/v1';
  static final ApiRepository _instance = ApiRepository._internal(); /// singleton api repository
  late ApiManager _apiManager; /// if you use Flutter version 1, remove late

  factory ApiRepository() {
    return _instance;
  }

  /// base configuration for api manager
  ApiRepository._internal() {
    _apiManager = ApiManager();
    _apiManager.options.baseUrl = BASE_URL; /// EX: BASE_URL = 'https://google.com/api/v1'
    _apiManager.options.connectTimeout = 100000;
    _apiManager.options.receiveTimeout = 100000;
    _apiManager.responseBodyWrapper('data'); /// This is used to parse the response without data attribute, some use case will shown below
    _apiManager.enableLogging(responseBody: true, requestBody: false); /// enable api logging EX: response, request, headers etc
    _apiManager.enableAuthTokenCheck(() => "access_token"); /// EX: JWT/PASSPORT auth token store in cache
  }
}

```

## Examples

Suppose we have a response model like this:

```dart
class SampleResponse{
  String name;
  int id;

  SampleResponse.fromJson(jsonMap): 
        this.name = jsonMap['name'],
        this.id = jsonMap['id'];
}
```
and actual api response json structure is:
```json
{
    "data": {
        "name": "md afratul kaoser taohid",
        "id": "id"
    }
}
```
#Now we Performing a `GET` request : 
```dart
 Future<ApiResponse<SampleResponse>> getRequestSample() async =>
      await _apiManager.request<SampleResponse>(
        requestType: RequestType.GET,
        route: 'api_route',
        requestParams: {"userId": 12}, /// add params if required
        isAuthRequired: true, /// by set it to true, this request add a header authorization from this method enableAuthTokenCheck();
        responseBodySerializer: (jsonMap) {
          return SampleResponse.fromJson(jsonMap); /// parse the json response into dart model class
        },
      );
```

#Now we Performing a `POST` request : 
```dart
 Future<ApiResponse<SampleResponse>> postRequestSample() async =>
      await _apiManager.request<SampleResponse>(
        requestType: RequestType.POST,
        route: 'api_route',
        requestBody: {"userId": 12}, /// add POST request body
        isAuthRequired: true, /// by set it to true, this request add a header authorization from this method enableAuthTokenCheck();
        responseBodySerializer: (jsonMap) {
          return SampleResponse.fromJson(jsonMap); /// parse the json response into dart model class
        },
      );
```

#Now er performing a multipart file upload request : 
```dart
  Future<ApiResponse<void>> updateProfilePicture(
    String filePath,
  ) async {
    MultipartFile multipartFile =
        await _apiManager.getMultipartFileData(filePath);
    FormData formData = FormData.fromMap({'picture': multipartFile});

    return await _apiManager.request(
      requestType: RequestType.POST,
      isAuthRequired: true,
      requestBody: formData,
      route: 'api_route',
    );
  }
```
