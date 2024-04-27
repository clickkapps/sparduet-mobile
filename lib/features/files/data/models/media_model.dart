import 'package:copy_with_extension/copy_with_extension.dart';
import '../store/enums.dart';

part 'media_model.g.dart';

@CopyWith()
class MediaModel {
  final String path;
  final MediaType type;

  const MediaModel({required this.path, required this.type});
}