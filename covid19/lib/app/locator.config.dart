// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:covid19/services/tncovidbeds_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<NavigationService>(() => NavigationService());
  gh.lazySingleton<SnackbarService>(() => SnackbarService());
  gh.lazySingleton<DialogService>(() => DialogService());
  gh.lazySingleton<TNCovidBedsService>(() => TNCovidBedsService());
  return get;
}
