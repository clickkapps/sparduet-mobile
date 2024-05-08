import 'package:cloudinary_url_gen/cloudinary.dart';

abstract final class AppConstants {
  static const double maximumVideoDuration = 30;
  static const double minimumVideoDuration = 2;
  static const double gridPageSize = 9;
  static Cloudinary? cloudinary;
  static String requestPostFeedAudioUrl = "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/fbcuueotbitapy16lyva.mp3";
  static String requestPostFeedVideoMediaId = "hbufms9ks3dmw6iqliga";
}


abstract final class NavPosition {
  static const int home = 0;
  static const int inbox = 1;
  static const int editor = 2;
  static const int profile = 3;
  static const int more = 4;
}