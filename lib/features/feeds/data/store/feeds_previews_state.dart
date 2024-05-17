import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';

part 'feeds_previews_state.g.dart';

@CopyWith()
class FeedsPreviewsState extends Equatable {

  final FeedStatus status;
  final String? message;
  final List<FeedModel> feeds;

  const FeedsPreviewsState({
    this.status = FeedStatus.initial,
    this.message,
    this.feeds = const []
  });

  @override
  List<Object?> get props => [status, feeds];

}