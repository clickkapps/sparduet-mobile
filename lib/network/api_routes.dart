
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
  static String getUserNotice = "$baseApiUrl/user/get-notice";
  static String markNoticeAsRead = "$baseApiUrl/user/mark-notice-as-read";
  static String reportUser = "$baseApiUrl/user/report-user";
  static String blockUser = "$baseApiUrl/user/block-user";
  static String unblockUser = "$baseApiUrl/user/unblock-user";
  static String setupUserLocation = "$baseApiUrl/auth/setup-location";
  static String userBlockStatus = "$baseApiUrl/user/block-status";

  static String fetchPostLikedUsers({required int? postId}) => "$baseApiUrl/user/liked/post/$postId";
  static String fetchOnlineUsers = "$baseApiUrl/user/online/get";
  static String addOnlineUser({required int? userId}) => "$baseApiUrl/user/online/add/$userId";
  static String removeOnlineUser({required int? userId}) => "$baseApiUrl/user/online/remove/$userId";
  static String getOnlineUserIds = "$baseApiUrl/user/online/ids";

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

  static const String getCountries = 'https://api.first.org/data/v1/countries?limit=249';

  static const String topSearch = '$baseApiUrl/search/top';
  static const String usersSearch = '$baseApiUrl/search/users';
  static const String storiesSearch = '$baseApiUrl/search/posts';
  static const String userSearchTerms = '$baseApiUrl/search/user-search-terms';
  static const String popularSearchTerms = '$baseApiUrl/search/popular-search-terms';

  static const String  fetchSettings = '$baseApiUrl/preferences/settings';
  static const String  updateSettings = '$baseApiUrl/preferences/update-settings';
  static const String  createFeedback = '$baseApiUrl/preferences/create-feedback';
  static const String  broadcastingAuth = '$webApiUrl/broadcasting/auth';

  // chat routes
  static const String  suggestedChatUsers = '$baseApiUrl/chat/suggested';
  static const String  sendChatMessage = '$baseApiUrl/chat/send-message';
  static const String  createChatConnection = '$baseApiUrl/chat/create-chat-connection';
  static const String  fetchChatConnections = '$baseApiUrl/chat/fetch-chat-connections';
  static const String  fetchChatMessages = '$baseApiUrl/chat/fetch-messages';
  static const String  markChatMessagesAsRead = '$baseApiUrl/chat/mark-messages-as-read';
  static String  getChatConnection(int? id) => '$baseApiUrl/chat/get-chat-connection/$id';
  static const String  getTotalUnreadChatMessages = '$baseApiUrl/chat/total-unread-chat-messages';
  static const String  deleteChatMessage = '$baseApiUrl/chat/delete-message';
  static const String  deleteChatConnection = '$baseApiUrl/chat/delete-connection';

  // notifications
  static String fetchNotifications = "$baseApiUrl/notifications";
  static String countUnseenNotifications = "$baseApiUrl/notifications/count-unseen-count";
  static String markNotificationsAsSeen = "$baseApiUrl/notifications/mark-as-seen";
  static String markNotificationAsRead({int? id}) => "$baseApiUrl/notifications/mark-as-read/$id";

  // disciplinary records
  static String getDisciplinaryRecord({required int? userId}) => "$baseApiUrl/user/get-disciplinary-record/$userId";
  static String markDisciplinaryRecordAsRead({required int? id}) => "$baseApiUrl/user/mark-disciplinary-as-read/$id";
}
