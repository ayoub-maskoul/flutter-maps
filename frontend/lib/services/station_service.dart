
import 'dart:convert';
import 'package:frontend/models/station.dart';
import 'package:frontend/services/api_response.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/constant.dart';
import 'package:http/http.dart' as http;


// Stations
Future<ApiResponse> getStations(city) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$stationsURL?city=$city'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      );

    switch(response.statusCode){
      case 200:
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status']) {
          final List<dynamic> stationList = jsonResponse['station'];
          apiResponse.data = Station.fromList(stationList);
        } else {
          apiResponse.error = somethingWentWrong; 
        }
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } 
  catch(e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}