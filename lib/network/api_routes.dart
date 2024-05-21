
import 'package:flutter/foundation.dart';

class AppApiRoutes {

  // static const String  webApiUrl = 'https://api.sparkduet.com';
  static const String  webApiUrl = kDebugMode ? "https://37b7-41-155-49-50.ngrok-free.app" : 'https://api.sparkduet.com';
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
  static const String createPost = '$baseApiUrl/posts/create-post';
  static String attachMediaToPost({int? postId}) => '$baseApiUrl/posts/attach-post-media/$postId';
  static String userPosts({int? userId}) => '$baseApiUrl/posts/user/$userId';
  static String bookmarkedUserPosts({int? userId}) => '$baseApiUrl/posts/bookmarked/user/$userId';

  // utils
  static const String uploadFiles = '$baseApiUrl/utils/upload-files';
  static const String createMuxUploadUrl = '$baseApiUrl/utils/mux-create-upload-url';
  static const String getUploadStatus = '$baseApiUrl/utils/mux-upload-status';
  static const String getVideoStatus = '$baseApiUrl/utils/mux-video-status';
}
