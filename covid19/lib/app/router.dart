import 'package:covid19/ui/covid_beds/covid_beds_list_view.dart';
import 'package:covid19/ui/district_selection/district_selection_view.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.DistrictView:
        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => DistrictSelectionView());
      case Routes.HospitalBeds:
        var district = settings.arguments;
        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => HospitalBedsView(district: district));
      default:
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (context) => Scaffold(
            body: Center(child: Text('No path for ${settings.name}')),
          ),
        );
    }
  }
}

class Routes {
  static const Home = 'home';
  static const Root = "/";
  static const DistrictView = "district";
  static const HospitalBeds = "hospital_beds";
}
