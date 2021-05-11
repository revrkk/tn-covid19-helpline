import 'package:covid19/app/locator.dart';
import 'package:covid19/app/router.dart';
import 'package:covid19/services/tncovidbeds_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DistrictSelectionViewModel extends BaseViewModel {
  final _tnCovidBedsService = locator<TNCovidBedsService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  var districts = [];
  var _selectedDistrict = {};

  get selectedDistrict => _selectedDistrict;
  set selectedDistrict(d) {
    _selectedDistrict = d;
    notifyListeners();
  }

  getDistricts() async {
    setBusy(true);
    var res = await _tnCovidBedsService.getDistricts();
    districts = res['result'];
    setBusy(false);
  }

  proceed() {
    if (selectedDistrict.isEmpty) {
      _snackbarService.showSnackbar(
          title: "Alert", message: "Please select a district to continue");
      return;
    }
    _navigationService.navigateTo(Routes.HospitalBeds,
        arguments: selectedDistrict);
  }
}
