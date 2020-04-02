import 'package:api_manager/api_manager.dart';

void main() async {
  ApiManager _apiManager = ApiManager();
  _apiManager.options.baseUrl = $base_url;
  _apiManager.responseBodyWrapper("data");

  ApiResponse<List<dynamic>> response = await _apiManager.request(
    requestType: RequestType.GET,
    route: $route,
    responseBodySerializer: (jsonMap) {
      return jsonMap as List;
    },
  );
  print(response);
}
