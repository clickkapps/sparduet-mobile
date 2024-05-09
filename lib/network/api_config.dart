
import 'package:flutter/foundation.dart';

class AppApiRoutes {

  // static const String  websiteUrl = 'https://api.sparkduet.com';
  static const String  websiteUrl = kDebugMode ? 'https://2e08-41-155-40-17.ngrok-free.app' : 'https://api.sparkduet.com';
  static const String baseApiUrl = '$websiteUrl/api';

  static const String  signUp = '$baseApiUrl/auth/';
  static const String  login = '$baseApiUrl/auth/login';
  static const String aboutUrl = '$websiteUrl/about';
  // static String  login = '$baseUrl/auth/login';

  static const String submitAuthEmail = '$baseApiUrl/auth/email';
  static const String authEmail = '$baseApiUrl/auth/email/verify';
  static String videoMediaPath({required mediaId}) => "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/$mediaId.mp4";
  static String imageMediaPath({required mediaId}) => "https://res.cloudinary.com/dhhyl4ygy/image/upload/f_auto,q_auto/v1/sparkduet/$mediaId";

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

}
