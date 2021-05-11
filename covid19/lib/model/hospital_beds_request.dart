// To parse this JSON data, do
//
//     final hospitalBedsRequest = hospitalBedsRequestFromJson(jsonString);

import 'dart:convert';

HospitalBedsRequest hospitalBedsRequestFromJson(String str) =>
    HospitalBedsRequest.fromJson(json.decode(str));

String hospitalBedsRequestToJson(HospitalBedsRequest data) =>
    json.encode(data.toJson());

class HospitalBedsRequest {
  HospitalBedsRequest({
    this.searchString,
    this.sortCondition,
    this.pageNumber,
    this.pageLimit,
    this.sortValue,
    this.districts,
    this.browserId,
    this.isGovernmentHospital,
    this.isPrivateHospital,
    this.facilityTypes,
  });

  String searchString;
  SortCondition sortCondition;
  int pageNumber;
  int pageLimit;
  String sortValue;
  List<String> districts;
  String browserId;
  bool isGovernmentHospital;
  bool isPrivateHospital;
  List<String> facilityTypes;

  factory HospitalBedsRequest.fromJson(Map<String, dynamic> json) =>
      HospitalBedsRequest(
        searchString: json["searchString"],
        sortCondition: SortCondition.fromJson(json["sortCondition"]),
        pageNumber: json["pageNumber"],
        pageLimit: json["pageLimit"],
        sortValue: json["SortValue"],
        districts: List<String>.from(json["Districts"].map((x) => x)),
        browserId: json["BrowserId"],
        isGovernmentHospital: json["IsGovernmentHospital"],
        isPrivateHospital: json["IsPrivateHospital"],
        facilityTypes: List<String>.from(json["FacilityTypes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "searchString": searchString,
        "sortCondition": sortCondition.toJson(),
        "pageNumber": pageNumber,
        "pageLimit": pageLimit,
        "SortValue": sortValue,
        "Districts": List<dynamic>.from(districts.map((x) => x)),
        "BrowserId": browserId,
        "IsGovernmentHospital": isGovernmentHospital,
        "IsPrivateHospital": isPrivateHospital,
        "FacilityTypes": List<dynamic>.from(facilityTypes.map((x) => x)),
      };
}

class SortCondition {
  SortCondition({
    this.name,
  });

  int name;

  factory SortCondition.fromJson(Map<String, dynamic> json) => SortCondition(
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
      };
}
