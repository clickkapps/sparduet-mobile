import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/foundation.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';

class AppChatHelper {

  static Future<CubeUser?> loginChatUser (AuthUserModel? authUser) async {
    try{
      final cubeUser = CubeUser(id: authUser?.id, email: authUser?.email, password: authUser?.publicKey);

      CubeUser chatUser;
      if(authUser?.firstLoginAt == authUser?.lastLoginAt) {
        chatUser  = await signUp(cubeUser);
      }else{
        chatUser = await signIn(cubeUser);
      }
      return chatUser;

    }catch(error) {
      debugPrint("customLog: connectycube error: $error");
      return null;
    }
  }

  static Future<CubeSession?> createChatUserSession (AuthUserModel? authUser) async {
    try{
      final cubeUser = CubeUser(id: authUser?.id, email: authUser?.email, password: authUser?.publicKey);
      final session = await createSession(cubeUser);
      return session;
    }catch(error) {
      debugPrint("customLog: connectycube error: $error");
      return null;
    }
  }


}