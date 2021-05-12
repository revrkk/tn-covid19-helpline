import 'package:covid19/app/locator.dart';
import 'package:covid19/model/hospital_beds_request.dart';
import 'package:covid19/services/tncovidbeds_service.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:covid19/utils/extensions.dart';

class HospitalBedsViewModel extends BaseViewModel {
  final _tnCovidBedsService = locator<TNCovidBedsService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  var isLoaded = false;

  var district = {};
  var hospitals = [];

  var severitySelection = [true, true, true];
  var hospitalTypes = [true, true];

  var searchQuery = "";
  int pageLimit = 100;
  int currentPage = 1;

  String bedsLastUpdatedDateTime(hospital) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(
                  hospital["CovidBedDetails"]["LastUpdatedTime"].toString()) *
              1000)
          .getDateDifference();

  get req {
    var severitySelections = <String>[];
    if (severitySelection[0]) {
      severitySelections.add('CCC');
    }
    if (severitySelection[1]) {
      severitySelections.add('CHC');
    }
    if (severitySelection[2]) {
      severitySelections.add('CHO');
    }
    return HospitalBedsRequest(
      searchString: searchQuery,
      sortCondition: SortCondition(name: 1),
      pageNumber: currentPage,
      pageLimit: pageLimit,
      sortValue: "O2 Bed Availability",
      districts: [district["id"].toString()],
      browserId: "cbcb2d4091ee8f2966ce362345dd1538",
      isGovernmentHospital: hospitalTypes[0],
      isPrivateHospital: hospitalTypes[1],
      facilityTypes: severitySelections,
    );
  }

  refresh() {
    notifyListeners();
  }

  navigateToDistrictSelection() async {
    _navigationService.back();
  }

  getHospitals() async {
    setBusy(true);
    print("Getting hospital list");
    var res = await _tnCovidBedsService.getHospitals(req);
    hospitals = res["result"];
    isLoaded = true;
    setBusy(false);
  }

  navigateToHospital(hospital) async {
    var lat = hospital["Latitude"];
    var lng = hospital["Longitude"];
    if (lat == null || lng == null) {
      _snackbarService.showSnackbar(message: "Unable to navigate");
      return;
    }

    final url = 'http://maps.google.com/maps?daddr=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  callHospital(String number) async {
    final url = 'tel://$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  shareHospitalDetails(hospital) async {
    var bed = hospital["CovidBedDetails"];
    List contactDetailsList = hospital["ContactDetails"];

    String contactDetailsText = "";
    for (var c in contactDetailsList) {
      contactDetailsText +=
          "${c["ContactNumber"] ?? ""} (${c["ContactName"] ?? ""})\n";
    }

    var messageText = """
    ${hospital["Name"]}

Vacant ICU Beds: ${bed["VaccantICUBeds"]}
Vaccant Oxygen Beds: ${bed["VaccantO2Beds"]}
Vacant Normal Beds: ${bed["VaccantNonO2Beds"]}

Facility: ${hospital["FacilityType"] ?? "-"}

Contact:
Landline: ${hospital["Landline"] ?? "-"}
MobileNumber: ${hospital["MobileNumber"] ?? "-"}
PrimaryContactPerson: ${hospital["PrimaryContactPerson"] ?? "-"}
$contactDetailsText

${hospital["AddressDetail"]["Line1"] ?? ""}
${hospital["AddressDetail"]["Line2"] ?? ""}
${hospital["AddressDetail"]["Line3"] ?? ""}
http://maps.google.com/maps?daddr=${hospital["Latitude"]},${hospital["Latitude"]}'

    """;
    Share.share(messageText);
  }
}
