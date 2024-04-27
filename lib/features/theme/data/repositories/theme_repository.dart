import 'package:sparkduet/core/app_storage.dart';
import 'package:sparkduet/network/network_provider.dart';

class ThemeRepository {

  final NetworkProvider networkProvider;
  final AppStorage localStorageProvider;

  const ThemeRepository({required this.networkProvider, required this.localStorageProvider});



}