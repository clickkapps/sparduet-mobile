
import 'package:flutter/foundation.dart';

class AppApiRoutes {

  static const String  webApiUrl = 'https://api.sparkduet.com';
  // static const String  websiteUrl = kDebugMode ? "https://9eab-41-155-49-50.ngrok-free.app" : 'https://api.sparkduet.com';
  static const String baseApiUrl = '$webApiUrl/api';

  static const String  signUp = '$baseApiUrl/auth/';
  static const String  login = '$baseApiUrl/auth/login';
  static const String aboutUrl = '$webApiUrl/about';
  static const String  updateProfile = '$baseApiUrl/auth/profile-update';

  static const String submitAuthEmail = '$baseApiUrl/auth/email';
  static const String authEmail = '$baseApiUrl/auth/email/verify';

  static String userProfile({int? userId}) {
    String url = '$baseApiUrl/user/profile';
    if(userId != null) {
      url = "$url/$userId";
    }
    return url;
  }

  static const String feeds = '$baseApiUrl/posts';
  static const String createFeed = '$baseApiUrl/posts/create';
  static String userPosts({int? userId}) => '$baseApiUrl/posts/user/$userId';
  static String bookmarkedUserPosts({int? userId}) => '$baseApiUrl/posts/bookmarked/user/$userId';

  // utils
  static const String uploadFiles = '$baseApiUrl/utils/upload-files';
}
