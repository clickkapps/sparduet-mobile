import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';

abstract final class AppConstants {
  static const double maximumVideoDuration = 30;
  static const double minimumVideoDuration = 2;
  static const int gridPageSize = 9;
  static const String website = "https://sparkduet.com";
  static const String blog = "$website/blog";
  static const String termsOfUse = "$website/terms-of-use";
  static const String privacyPolicy = "$website/privacy-policy";
  static const String faq = "$website/faq";
  static Cloudinary? cloudinary;
  // static const String testVideoUrl = "https://stream.mux.com/qDoywC02xt9SvqU1S2n00phorcTHPFOATBvCggHt005lds.m3u8";
  // static String requestPostFeedAudioUrl = "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/fbcuueotbitapy16lyva.mp3";
  // static String requestPostFeedAudioUrl = "https://stream.mux.com/bJXeC2UGUynh7wz8XoUECaIk82xsNefGYzPoT5hIet8.m3u8";
  static String requestPostFeedVideoMediaId = "SqjS5qaNZrres2FQACE5W4ZNdXxMagdeOVoqIq2x3zU";
  // static String videoMediaPath({required mediaId}) => "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/$mediaId.mp4";
  // static String imageMediaPath({required mediaId}) => "https://res.cloudinary.com/dhhyl4ygy/image/upload/f_auto,q_auto/v1/sparkduet/$mediaId";
  static String videoMediaPath({required String playbackId}) => "https://stream.mux.com/$playbackId.m3u8";
  static String imageMediaPath({required String mediaId}) => "https://d2e46virtl8cds.cloudfront.net/$mediaId";
  static String audioMediaPath({required String mediaId}) => "https://d2e46virtl8cds.cloudfront.net/$mediaId";
  static String thumbnailMediaPath({required String mediaId}) => "https://image.mux.com/$mediaId/thumbnail.webp";
  static String defaultAudioLink = "https://d2e46virtl8cds.cloudfront.net/track_1.mp3";
  static List<String> audioLinks = <String>[
    audioMediaPath(mediaId: "track_1.mp3"),
    audioMediaPath(mediaId: "track_2.mp3"),
    audioMediaPath(mediaId: "track_3.mp3"),
    audioMediaPath(mediaId: "track_4.mp3"),
    audioMediaPath(mediaId: "track_5.mp3"),
  ];
  static PostFeedPurpose introductoryPostFeedPurpose = const PostFeedPurpose(
      title: "Hi✋, Let's get started",
      subTitle: "Introduce yourself to potential suitors. A good 30 sec video will attract the best suitors",
      key: "introduction",
      description: "Hey✋, let's connect and learn more about each other.",
      expectedFile: ExpectedFiles.video
  );
  static PostFeedPurpose nextRelationshipExpectationPostFeedPurpose = const PostFeedPurpose(
      title: "Hi✋! what are you looking for in your next relationship?",
      subTitle: "A quick 30-second video sharing your expectations would be great for potential matches",
      key: "expectations",
      description: "What I'm looking for in my next relationship",
      expectedFile: ExpectedFiles.video
  );

  static PostFeedPurpose previousRelationshipPostFeedPurpose = const PostFeedPurpose(
      title: "Hi✋! let's talk about your previous relationship.",
      subTitle: "Share a quick 30-second video about your experience in your previous relationship",
      key: "previousRelationship",
      description: "My experiences in my previous relationship",
      expectedFile: ExpectedFiles.video
  );
  static PostFeedPurpose yourCareerPostFeedPurpose = const PostFeedPurpose(
      title: "Hi✋! let's talk about your career",
      subTitle: "Share a quick 30-second video about what you currently do to potential matches. PS: DO NOT reveal confidential issues",
      key: "career",
      description: "What I do currently",
      expectedFile: ExpectedFiles.video
  );
  static PostFeedPurpose otherPostFeedPurpose = const PostFeedPurpose(
      title: "Hi✋! what's on your mind?",
      subTitle: "Share a quick 30-second video to potential suitors",
      key: "other",
      description: "",
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

  static final List<Map<String, String>> races = [
    {
      "key": "american_indian_or_alaska_native",
      "name": "American Indian or Alaska Native"
    },
    {
      "key": "asian",
      "name": "Asian"
    },
    {
      "key": "black_or_african_american",
      "name": "Black or African American"
    },
    {
      "key": "middle_eastern_or_north_african",
      "name": "Middle Eastern or North African"
    },
    {
      "key": "native_hawaiian_or_other_pacific_islander",
      "name": "Native Hawaiian or other Pacific Islander"
    },
    {
      "key": "hispanic_latino_or_spanish_origin",
      "name": "Hispanic, Latino, or Spanish origin"
    },
    {
      "key": "white",
      "name": "White"
    },
    {
      "key": "other",
      "name": "Other"
    },
  ];

  static const List<Map<String, String>> preferredGenderList = [
    {
      "key": "men",
      "name": "Men"
    },
    {
      "key": "women",
      "name": "Women"
    },
    {
      "key": "transgenders",
      "name": "Transgenders"
    },
    {
      "key": "non_binary_or_non_conforming",
      "name": "Non-binary / non-conforming"
    },
    {
      "key": "any",
      "name": "Any"
    }
  ];

  static final List<Map<String, String>> preferredRaces = [
    {
      "key": "american_indian_or_alaska_native",
      "name": "American Indian or Alaska Native"
    },
    {
      "key": "asian",
      "name": "Asian"
    },
    {
      "key": "black_or_african_american",
      "name": "Black or African American"
    },
    {
      "key": "middle_eastern_or_north_african",
      "name": "Middle Eastern or North African"
    },
    {
      "key": "native_hawaiian_or_other_pacific_islander",
      "name": "Native Hawaiian or other Pacific Islander"
    },
    {
      "key": "hispanic_latino_or_spanish_origin",
      "name": "Hispanic, Latino, or Spanish origin"
    },
    {
      "key": "white",
      "name": "White"
    },
    {
      "key": "any",
      "name": "Any"
    },
  ];


}


abstract final class NavPosition {
  static const int home = 0;
  static const int inbox = 1;
  static const int editor = 2;
  static const int profile = 3;
  static const int more = 4;
}