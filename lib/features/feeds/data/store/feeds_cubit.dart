import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/data/classes/post_feed_request.dart';
import 'package:sparkduet/features/feeds/data/models/feed_broadcast_event.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_repository.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/files/data/models/media_model.dart';
import 'package:sparkduet/features/files/data/repositories/file_repository.dart';
import 'package:sparkduet/features/files/data/store/enums.dart';
import 'package:uuid/uuid.dart';

class FeedsCubit extends Cubit<FeedState> {

  final FeedRepository feedsRepository;
  final FileRepository fileRepository;
  final FeedBroadcastRepository feedBroadcastRepository;
  StreamSubscription<FeedBroadCastEvent>? feedBroadcastRepositoryStreamListener;
  FeedsCubit(this.fileRepository, {required this.feedsRepository, required this.feedBroadcastRepository}): super(const FeedState()) {
    listenForFeedUpdate();
  }

  /// This method updates feed when there's a change in state
  void listenForFeedUpdate() async {

    await feedBroadcastRepositoryStreamListener?.cancel();
    feedBroadcastRepositoryStreamListener = feedBroadcastRepository.stream.listen((FeedBroadCastEvent event) {

      final copiedFeeds = [...state.feeds];
      // update the corresponding feed
      if(event.action == FeedBroadcastAction.update){
        final feedIndex = copiedFeeds.indexWhere((element) => element.id == event.feed!.id);
        if(feedIndex > -1){
          copiedFeeds[feedIndex] = event.feed!;
          emit(state.copyWith(feeds: copiedFeeds));
        }

      }

      if(event.action == FeedBroadcastAction.delete){
        final feedIndex = copiedFeeds.indexWhere((element) => element.id == event.feed!.id);
        if(feedIndex > -1){
          copiedFeeds.removeAt(feedIndex);
        }
        emit(state.copyWith( feeds: copiedFeeds));

      }

    });
  }

  @override
  Future<void> close() async {
    feedBroadcastRepositoryStreamListener?.cancel();
    super.close();
  }

  /// Create a new feed // This is automatically triggered
  void postFeed({
    required File file,
    required FileType mediaType,
    String? purpose, String? description, bool commentsDisabled = false
  }) async {


    // This additional stuff is to ensure that we track the post request
    const uuid = Uuid();
    final postId = uuid.v1();
    final postRequests = <PostFeedRequest>[...state.postRequests];
    final postReq = PostFeedRequest(id: postId, media: MediaModel(path: file.path, type: mediaType), status: PostItemStatus.loading);
    postRequests.add(postReq);
    final postReqIndex = postRequests.length - 1;
    emit(state.copyWith(status: FeedStatus.postFeedInProgress, postRequests: postRequests));

    // start upload
    final uploadResponse = await fileRepository.uploadFileToCloudinary(files: [file]);

    if(uploadResponse.isLeft()){
      final l = uploadResponse.asLeft();
      final postRequests = <PostFeedRequest>[...state.postRequests];
      postRequests[postReqIndex] = postReq.copyWith(status: PostItemStatus.failed);
      emit(state.copyWith(status: FeedStatus.postFeedFailed, message: l, postRequests: postRequests));
      return;
    }

    final filePath = uploadResponse.asRight();
    final media =  MediaModel(path: filePath, type: mediaType);

    // create actual post
    final postResponse = await feedsRepository.postFeed(purpose: purpose, media: media, description: description, commentsDisabled: commentsDisabled);
    if(postResponse.isLeft()) {
      final l = postResponse.asLeft();
      final postRequests = <PostFeedRequest>[...state.postRequests];
      postRequests[postReqIndex] = postReq.copyWith(status: PostItemStatus.failed);
      emit(state.copyWith(status: FeedStatus.postFeedFailed, message: l, postRequests: postRequests));
      return;
    }

    final requests = <PostFeedRequest>[...state.postRequests];
    requests.removeAt(postReqIndex);
    emit(state.copyWith(status: FeedStatus.postFeedSuccessful,  postRequests: requests));

  }


  //! Fetch feeds and update the app's state as well as the UI
  Future<(String?, List<FeedModel>?)> fetchFeeds({required String path, required int pageKey, Map<String, dynamic>? queryParams}) async {

    emit(state.copyWith(status: FeedStatus.fetchFeedsInProgress));
    final either = await feedsRepository.fetchFeeds(path);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: FeedStatus.fetchFeedsFailed, message: l));
      return (l, null);
    }

    final newItems = either.asRight();
    final List<FeedModel> feeds = [...state.feeds];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      feeds.clear();
    }
    feeds.addAll(newItems);

    emit(state.copyWith(status: FeedStatus.fetchFeedsSuccessful,
        feeds: feeds
    ));

    return (null, newItems);
  }


}