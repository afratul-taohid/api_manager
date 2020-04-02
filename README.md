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
  ApiManager _apiManager = ApiManager();
  _apiManager.options.baseUrl = "your base url";

  ApiResponse<Map<String, dynamic>> response = await _apiManager.request(
    requestType: RequestType.GET,
    route: "your route",
  );
  print(response);
}
```