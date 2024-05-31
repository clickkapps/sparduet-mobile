import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';

class AppStorage {

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
// Create storage
  static final storage =  FlutterSecureStorage(aOptions: _getAndroidOptions());

  static const String _authTokenKey = 'authTokenKey';
  static const String _authUserKey = 'authUserKey';

  setAuthTokenVal(String value) async => await storage.write(key: _authTokenKey, value: value);

  Future<void> removeAuthTokenVal() async {
    await storage.delete(key: _authTokenKey);
  }
  Future<String?> getAuthTokenVal() async {
    return await storage.read(key: _authTokenKey);
  }

  Future<AuthUserModel?> getAuthUserFromLocalStorage() async {
    final str = await getFromPref(key: _authUserKey);
    if(str == null) return null;
    return AuthUserModel.fromJson(json.decode(str));
  }

  Future<void> saveAuthUserToLocalStorage(AuthUserModel authUser) async {
    final authUserJson = authUser.toJson();
    await saveToPref(key: _authUserKey, value: json.encode(authUserJson));
  }

  Future<void> removeAuthUserFromLocalStorage() async {
     await removeFromPref(key: _authUserKey);
  }

  Future<void> saveToPref({required String key, required String value}) async{
    // Write value
    await storage.write(key: key, value: value);
  }

  Future<String?> getFromPref({required String key}) async {
// Read value
    String? value = await storage.read(key: key);
    return value;
  }

  removeFromPref({required String key}) async {
    // Delete value
    await storage.delete(key: key);
  }



}