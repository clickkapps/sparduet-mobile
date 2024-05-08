import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_purpose.dart';
import 'package:sparkduet/features/files/data/models/media_model.dart';

part 'post_feed_request.g.dart';

enum PostItemStatus { loading, failed, success }

@CopyWith()
class PostFeedRequest extends Equatable{
  final String id;
  final MediaModel media;
  final PostFeedPurpose? purpose;
  final PostItemStatus status;

  const PostFeedRequest({required this.id, required this.media, this.purpose, required this.status});

  @override
  List<Object?> get props => [id, status];
}