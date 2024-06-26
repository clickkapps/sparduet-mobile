abstract final class AppAssets {
  static const String _imagePath = 'assets/img';
  static const String avatar = "$_imagePath/avatar.png";
  static const String premiumHeaderImage = "$_imagePath/premium_header_image.jpg";

  static const _jsonPath = 'assets/json';
  static const kEmptyChatJson = '$_jsonPath/empty_chat.json'; // used by app
  static const ksubSuccessJson = '$_jsonPath/sub_success.json'; // used by app
  static const kFirstImpressJson = '$_jsonPath/first_impression.json'; // used by app
  static const kLocationRequestJson = '$_jsonPath/location_request.json'; // used by app
  static const kMatchedConversationsJson = '$_jsonPath/matched_coversations.json'; // used by app
}