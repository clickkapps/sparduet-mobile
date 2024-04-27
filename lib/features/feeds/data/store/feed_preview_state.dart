import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';

part 'feed_preview_state.g.dart';

@CopyWith()
class FeedPreviewState extends Equatable {

  final FeedStatus status;
  final String? message;
  final FeedModel? feed;

  const FeedPreviewState({
    this.status = FeedStatus.initial,
    this.message,
    this.feed
  });

  @override
  List<Object?> get props => [status, feed];

}