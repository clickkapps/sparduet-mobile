abstract final class AppRoutes {
  static const String home = "/";
  static const String inbox = "/inbox";
  static String chat({String? connectionId}) => "$inbox/id:";
  static const String authProfile = "/auth-profile";
  static const String preferences = "/preferences";
  static const String login = "/login";
  static const String camera = "/camera";
  static const String photoGalleryPage = "/photo-gallery";
}