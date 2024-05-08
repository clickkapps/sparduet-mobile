import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../store/enums.dart';

part 'media_model.g.dart';

@CopyWith()
class MediaModel extends Equatable{
  final String path;
  final FileType type;

  const MediaModel({required this.path, required this.type});

  @override
  List<Object?> get props => [path, type];
}