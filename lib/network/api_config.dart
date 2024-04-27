
class ApiConfig {

  static const String  websiteUrl = 'https://api.sparkduet.com';
  // static const String  websiteUrl = 'https://d9ee-41-155-34-4.ngrok-free.app';
  static const String baseApiUrl = '$websiteUrl/api';

  static const String  signUp = '$baseApiUrl/auth/';
  static const String  login = '$baseApiUrl/auth/login';
  static const String aboutUrl = '$websiteUrl/about';
  // static String  login = '$baseUrl/auth/login';

  static const String submitAuthEmail = '$baseApiUrl/auth/email';
  static const String authEmail = '$baseApiUrl/auth/email/verify';

  static String userProfile({int? userId}) {
    String url = '$baseApiUrl/user/profile';
    if(userId != null) {
      url = "$url/$userId";
    }
    return url;
  }

  static const String feeds = '$baseApiUrl/stories';

}
