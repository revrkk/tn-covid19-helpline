import 'dart:convert';
import 'package:covid19/model/hospital_beds_request.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TNCovidBedsService {
  static const _baseUrl = "https://tncovidbeds.tnega.org/api";

  final _httpClient = Client();

  getDistricts() async {
    var res = await _httpClient.get("$_baseUrl/district");
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to get district list");
    }
  }

  getHospitals(HospitalBedsRequest req) async {
    var jsonBody = hospitalBedsRequestToJson(req);
    var res = await _httpClient.post("$_baseUrl/hospitals",
        headers: {"Content-Type": "application/json"}, body: jsonBody);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to get hospital list");
    }
  }
}
