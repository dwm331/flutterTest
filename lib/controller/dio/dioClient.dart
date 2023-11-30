import 'package:dio/dio.dart';
import '../../model/spot.dart';

class DioClient {
  final Dio _dio = Dio();
  final _baseUrl = 'https://api.kcg.gov.tw:443/api';

  List<Spot> parseSpots(List responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Spot>((json) => Spot.fromJson(json)).toList();
  }

  Future<List<Spot>> fetchSpots() async {
    final Response spotData = await _dio
        .get('$_baseUrl/service/get/9c8e1450-e833-499c-8320-29b36b7ace5c');
    var jsonDict = spotData.data as Map<String, dynamic>? ?? {};
    if (jsonDict['data'].isEmpty) return [];
    if (jsonDict['data']['XML_Head'].isEmpty) return [];
    if (jsonDict['data']['XML_Head']["Infos"].isEmpty) return [];
    if (jsonDict['data']['XML_Head']["Infos"]["Info"].isEmpty) return [];
    return parseSpots(jsonDict['data']['XML_Head']["Infos"]["Info"]);
  }
}
