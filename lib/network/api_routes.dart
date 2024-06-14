
import 'package:flutter/foundation.dart';

class AppApiRoutes {

  static const String  webApiUrl = 'https://api.sparkduet.com';
  // static const String  webApiUrl = kDebugMode ? "https://09e3-41-155-34-9.ngrok-free.app" : 'https://api.sparkduet.com';
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

  static String saveProfileView = "$baseApiUrl/user/record-profile-view";
  static String markProfileViewAsRead = "$baseApiUrl/user/mark-profile-view-as-read";
  static String fetchUnreadProfileViewers = "$baseApiUrl/user/fetch-unread-profile-viewers";
  static String countUnreadProfileViewers = "$baseApiUrl/user/count-unread-profile-views";

  static const String feeds = '$baseApiUrl/posts';
  static const String createPost = '$baseApiUrl/posts/create-post';
  static String attachMediaToPost({int? postId}) => '$baseApiUrl/posts/attach-post-media/$postId';
  static String userPosts({int? userId}) => '$baseApiUrl/posts/user/$userId';
  static String bookmarkedUserPosts({int? userId}) => '$baseApiUrl/posts/bookmarked/user/$userId';

  static String togglePostLikeAction({int? postId}) => '$baseApiUrl/posts/like/$postId';
  static String togglePostBookmarkAction({int? postId}) => '$baseApiUrl/posts/bookmark/$postId';
  static String viewPostAction({int? postId}) => '$baseApiUrl/posts/view/$postId';
  static String reportPostAction({int? postId}) => '$baseApiUrl/posts/report/$postId';
  // togglePostLikeAction
  // utils
  static const String uploadFiles = '$baseApiUrl/utils/upload-files';
  static const String createMuxUploadUrl = '$baseApiUrl/utils/mux-create-upload-url';
  static const String getUploadStatus = '$baseApiUrl/utils/mux-upload-status';
  static const String getVideoStatus = '$baseApiUrl/utils/mux-video-status';

  static const String getCountries = 'https://api.first.org/data/v1/countries';

  static const String topSearch = '$baseApiUrl/search/top';
  static const String usersSearch = '$baseApiUrl/search/users';
  static const String storiesSearch = '$baseApiUrl/search/posts';
  static const String userSearchTerms = '$baseApiUrl/search/user-search-terms';
  static const String popularSearchTerms = '$baseApiUrl/search/popular-search-terms';

  static const String  fetchSettings = '$baseApiUrl/preferences/settings';
  static const String  updateSettings = '$baseApiUrl/preferences/update-settings';
  static const String  createFeedback = '$baseApiUrl/preferences/create-feedback';
  static const String  broadcastingAuth = '$webApiUrl/broadcasting/auth';
  static String webSocketConnection({required int? userId}) => "users.$userId";

  // chat routes
  static const String  suggestedChatUsers = '$baseApiUrl/chat/suggested';
  static const String  createChatConnection = '$baseApiUrl/chat/create-chat-connection';
  static const String  fetchChatConnections = '$baseApiUrl/chat/fetch-chat-connections';
  static String  getChatConnection(int? id) => '$baseApiUrl/chat/get-chat-connection/$id';
}
