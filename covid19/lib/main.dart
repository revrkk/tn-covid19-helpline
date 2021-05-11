import 'package:covid19/app/locator.dart';
import 'package:covid19/app/router.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  setupLocator();
  runApp(Covid19App());
}

class Covid19App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TN Covid19 Helpline',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: Routes.DistrictView,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
