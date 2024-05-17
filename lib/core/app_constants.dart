import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';

abstract final class AppConstants {
  static const double maximumVideoDuration = 30;
  static const double minimumVideoDuration = 2;
  static const double gridPageSize = 9;
  static const String website = "https://sparkduet.com";
  static const String blog = "$website/blog";
  static const String termsOfUse = "$website/terms-of-use";
  static const String privacyPolicy = "$website/privacy-policy";
  static const String faq = "$website/faq";
  static Cloudinary? cloudinary;
  static const String testVideoUrl = "https://stream.mux.com/qDoywC02xt9SvqU1S2n00phorcTHPFOATBvCggHt005lds.m3u8";
  static String requestPostFeedAudioUrl = "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/fbcuueotbitapy16lyva.mp3";
  static String requestPostFeedVideoMediaId = "5820799-hd_1080_1920_30fps.mp4";
  // static String videoMediaPath({required mediaId}) => "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/$mediaId.mp4";
  // static String imageMediaPath({required mediaId}) => "https://res.cloudinary.com/dhhyl4ygy/image/upload/f_auto,q_auto/v1/sparkduet/$mediaId";
  static String videoMediaPath({required mediaId}) => "https://d2e46virtl8cds.cloudfront.net/$mediaId";
  static String imageMediaPath({required mediaId}) => "https://d2e46virtl8cds.cloudfront.net/$mediaId";
  static PostFeedPurpose introductoryPostFeedPurpose = const PostFeedPurpose(
      title: "Hi✋, Let's get started",
      subTitle: "Introduce yourself to potential suitors. A good 30 sec video will attract the best suitors",
      key: "introduction",
      description: "Hey✋, let's connect and learn more about each other.",
      expectedFile: ExpectedFiles.video
  );
  static PostFeedPurpose nextRelationshipExpectationPostFeedPurpose = const PostFeedPurpose(
      title: "Hi✋! What are you looking for in your next relationship?",
      subTitle: "A quick 30-second video sharing your expectations would be helpful for potential matches",
      key: "expectations",
      description: "What I'm looking for in my next relationship",
      expectedFile: ExpectedFiles.video
  );


  static const List<Map<String, String>> genderList = [
    {
      "key": "male",
      "name": "Male"
    },
    {
      "key": "female",
      "name": "Female"
    },
    {
      "key": "transgender",
      "name": "Transgender"
    },
    {
      "key": "non_binary_or_non_conforming",
      "name": "Non-binary / non-conforming"
    }
  ];

}


abstract final class NavPosition {
  static const int home = 0;
  static const int inbox = 1;
  static const int editor = 2;
  static const int profile = 3;
  static const int more = 4;
}