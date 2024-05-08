import 'dart:ui';

import 'package:sparkduet/core/app_storage.dart';
import 'package:sparkduet/features/theme/data/store/enums.dart';
import 'package:sparkduet/network/network_provider.dart';

class ThemeRepository {

  final NetworkProvider networkProvider;
  final AppStorage localStorageProvider;

  const ThemeRepository({required this.networkProvider, required this.localStorageProvider});

  Future<void> saveThemeMode({required Brightness brightness}) async {
    await localStorageProvider.saveToPref(key: "appBrightness", value: brightness.name);
  }
  Future<Brightness?> getThemeMode() async {
    final value = await localStorageProvider.getFromPref(key: "appBrightness");
    if(value == null) return null;
    return Brightness.values.byName(value);
  }

  Future<void> saveAppFont({required AppFont appFont}) async {
   await localStorageProvider.saveToPref(key: "appFont", value: appFont.name);
  }

  Future<AppFont?> getAppFont() async {
    final value = await localStorageProvider.getFromPref(key: "appFont");
    if(value == null) return null;
    return AppFont.values.byName(value);
  }

}