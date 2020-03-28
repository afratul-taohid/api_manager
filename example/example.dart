import 'package:api_manager/api_manager.dart';

void main() async {
  ApiManager _apiManager = ApiManager();
  _apiManager.options.baseUrl = "http://61.247.188.124:8009/api/v1/";

  ApiResponse<Map<String, dynamic>> response = await _apiManager.request(
    requestType: RequestType.GET,
    route: "front/job-postings",
  );
  print(response);
}
