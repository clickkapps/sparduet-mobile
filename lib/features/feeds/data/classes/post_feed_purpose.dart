import 'package:file_picker/file_picker.dart';
enum ExpectedFiles { any, video, photo }
class PostFeedPurpose {
  final String title;
  final String subTitle;
  final String key;
  final String description;
  final ExpectedFiles expectedFile;

  const PostFeedPurpose({
    required this.title,
    required this.subTitle,
    required this.key,
    required this.description,
    this.expectedFile = ExpectedFiles.any
  });
}