import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/core/app_post_converter.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/feeds/data/models/feed_broadcast_event.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_repository.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/files/data/models/media_model.dart';
import 'package:sparkduet/features/files/data/repositories/file_repository.dart';
import 'package:sparkduet/features/home/data/repositories/socket_connection_repository.dart';
import 'package:uuid/uuid.dart';

class FeedsCubit extends Cubit<FeedState> {

  final FeedRepository feedsRepository;
  final FileRepository fileRepository;
  final FeedBroadcastRepository feedBroadcastRepository;
  StreamSubscription<FeedBroadCastEvent>? feedBroadcastRepositoryStreamListener;
  FeedsCubit({required this.fileRepository, required this.feedsRepository, required this.feedBroadcastRepository,}): super(const FeedState()) {
    listenForFeedUpdate();
  }

  void clearState() {
    emit(const FeedState());
  }

  /// This method updates feed when there's a change in state
  void listenForFeedUpdate() async {

    await feedBroadcastRepositoryStreamListener?.cancel();
    feedBroadcastRepositoryStreamListener = feedBroadcastRepository.stream.listen((FeedBroadCastEvent event) {

      emit(state.copyWith(status: FeedStatus.feedBroadcastActionInProgress));
      final copiedFeeds = [...state.feeds];
      // update the corresponding feed
      if(event.action == FeedBroadcastAction.update){
        final feedIndex = copiedFeeds.indexWhere((element) => element.id == event.feed!.id);
        if(feedIndex > -1){
          copiedFeeds[feedIndex] = event.feed!;
          // emit(state.copyWith(feeds: copiedFeeds, status: FeedStatus.updateFeedCompleted));
          refreshList(updatedFeeds: copiedFeeds);
        }
      }
      if(event.action == FeedBroadcastAction.censorUpdated){
        final feedId = event.data['id'] as int?;
        final disAction = event.data['action'] as String?;
        final feedIndex = copiedFeeds.indexWhere((element) => element.id == feedId);
        if(feedIndex > -1) {
          copiedFeeds[feedIndex] = copiedFeeds[feedIndex].copyWith(
            disciplinaryAction: disAction
          );
          // emit(state.copyWith(feeds: copiedFeeds, status: FeedStatus.updateFeedCompleted));
          refreshList(updatedFeeds: copiedFeeds);
        }
      }

      if(event.action == FeedBroadcastAction.delete){
        final feedIndex = copiedFeeds.indexWhere((element) => element.id == event.feed!.id);
        if(feedIndex > -1){
          copiedFeeds.removeAt(feedIndex);
          emit(state.copyWith( feeds: copiedFeeds, status: FeedStatus.deleteFeedCompleted));
          refreshList(updatedFeeds: copiedFeeds);
        }

      }

    });
  }

  @override
  Future<void> close() async {
    feedBroadcastRepositoryStreamListener?.cancel();
    super.close();
  }

  void setBackgroundHasRefreshedFeed({bool hasRefreshed = false}) async {
    emit(state.copyWith(status: FeedStatus.setBackgroundHasRefreshedFeedInProgress));
    emit(state.copyWith(status: FeedStatus.setBackgroundHasRefreshedFeedCompleted, backgroundHasRefreshedFeeds: hasRefreshed));
  }

  /// Create a new feed // This is automatically triggered
  void postFeed({
    required File file,
    required FileType mediaType,
    String? purpose,
    String? description,
    bool commentsDisabled = false,
    bool flipFile = false,
    String? tempPostId,
    required AuthUserModel? user
  }) async {


    // This additional stuff is to ensure that we track the post request
    final postTempId =  tempPostId  ?? const Uuid().v1();

    /// set post as loading
    void setLoading() {
      final existingFeeds = <FeedModel>[...state.feeds];
      final existingTempFeedIndex = existingFeeds.indexWhere((element) => element.tempId == postTempId);
      final newFeed = FeedModel(
          tempId: postTempId,
          mediaPath: file.path,
          mediaType: mediaType,
          status: "loading",
          purpose: purpose,
          description: description,
          commentsDisabledAt: commentsDisabled ? DateTime.now() : null,
          flipFile: flipFile,
          user: user
      );

      // for the purposes of retry
      if(existingTempFeedIndex > -1) {
        existingFeeds[existingTempFeedIndex] = newFeed;
      }else {
        existingFeeds.insert(0, newFeed);
      }

      refreshList(updatedFeeds: existingFeeds);
      emit(state.copyWith(status: FeedStatus.postFeedInProgress));

    }

    void updatePostId(int postId) {
      final existingFeeds = <FeedModel>[...state.feeds];
      final existingTempFeedIndex = existingFeeds.indexWhere((element) => element.tempId == postTempId);
      if(existingTempFeedIndex > -1) {
        existingFeeds[existingTempFeedIndex] = existingFeeds[existingTempFeedIndex].copyWith(
          id: postId,
          // status: null
        );
      }
      refreshList(updatedFeeds: existingFeeds);
      emit(state.copyWith(status: FeedStatus.postFeedSuccessful, data: {"feed": existingFeeds[existingTempFeedIndex]}));
    }

    ///! function to set post as failed
    void setError(String error) {
      final existingFeeds = <FeedModel>[...state.feeds];
      final postIndex = existingFeeds.indexWhere((element) => element.tempId == postTempId);
      existingFeeds[postIndex] = existingFeeds[postIndex].copyWith(status: "failed");
      refreshList(updatedFeeds: existingFeeds);
      emit(state.copyWith(status: FeedStatus.postFeedFailed, message: error));
    }

    ///! set Post as successful
    void setCompleted(FeedModel feed) {
      final existingFeeds = <FeedModel>[...state.feeds];
      final postIndex = existingFeeds.indexWhere((element) => element.tempId == postTempId);
      if(postIndex > -1) {
        existingFeeds[postIndex] = feed;
      }
      refreshList(updatedFeeds: existingFeeds);
      emit(state.copyWith(status: FeedStatus.postFeedProcessFileCompleted, data: feed));
    }

    //! update ui as loading image
    setLoading();


    // Initiate post without the post media
    final postResponse = await feedsRepository.createPost(purpose: purpose, media: MediaModel(path: "", type: mediaType), description: description, commentsDisabled: commentsDisabled);
    if(postResponse.isLeft()) {
      final l = postResponse.asLeft();
      setError(l);
      return;
    }

    // this has everything except the media
    final initialPostId = postResponse.asRight();

    // update post with serverId
    // This will mark the post as completed whiles we process the file
    updatePostId(initialPostId);



    emit(state.copyWith(status: FeedStatus.postFeedProcessFileInProgress));

    MediaModel? mediaFile;

    if(mediaType == FileType.image) {
      ///! Image section

      final imageFilesResponse = await fileRepository.uploadFilesToServer(files: <File>[file]);

      if(imageFilesResponse.isLeft()){
        final l = imageFilesResponse.asLeft();
        setError(l);
        return;
      }

      final imagePath = imageFilesResponse.asRight().first;
      mediaFile =  MediaModel(path: imagePath, type:  mediaType, assetId: imagePath);


    }
    else {

      ///! Video section
      ///

      File? postFile;

      //! Flip file if its front camera
      // if(flipFile) {
      //   postFile = await AppPostConverter.flipVideo(file);
      // }
      final uploadResponse = await fileRepository.uploadVideoToServer(videoFile: postFile ?? file);

      if(uploadResponse.isLeft()){
        final l = uploadResponse.asLeft();
        setError(l);
        return;
      }

      final upld = uploadResponse.asRight();
      final filePath = upld.$1;
      final assetId = upld.$2;
      final aspectRatio = upld.$3;
      mediaFile =  MediaModel(path: filePath, type: mediaType, assetId: assetId, aspectRatio: aspectRatio);


    }


    // attach media file to server
    final attachMediaResponse = await feedsRepository.attachMediaToPost(postId: initialPostId, media: mediaFile);
    if(attachMediaResponse.isLeft()) {
      final l = attachMediaResponse.asLeft();
      setError(l);
      return;
    }

    final completedPost = attachMediaResponse.asRight();
    setCompleted(completedPost);


  }


  //! Fetch feeds and update the app's state as well as the UI
  Future<(String?, List<FeedModel>?)> fetchFeeds({required String path, required int pageKey, Map<String, dynamic>? queryParams, bool returnExistingFeedsForFirstPage = false}) async {


    final uncompletedFeeds = state.feeds.where((element) => element.id == null).toList();
    // if(uncompletedFeeds.isNotEmpty && pageKey == 1) {
    //   emit(state.copyWith(status: FeedStatus.fetchFeedsInProgress));
    //   emit(state.copyWith(status: FeedStatus.unCompletedPostsWithFeeds, feeds: state.feeds));
    // }

    // if(pageKey == )

    emit(state.copyWith(status: FeedStatus.fetchFeedsInProgress, ));

    // return cached items
    if(returnExistingFeedsForFirstPage) {
      if(pageKey == 1 && state.feeds.isNotEmpty) {
        emit(state.copyWith(status: FeedStatus.fetchFeedsSuccessful,
            data: { "pageKey": pageKey }
        ));
        return (null, state.feeds);
      }
    }

    final either = await feedsRepository.fetchFeeds(path, queryParams: queryParams);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: FeedStatus.fetchFeedsFailed, message: l));
      return (l, null);
    }

    var newItems = either.asRight();
    final List<FeedModel> feeds = <FeedModel>[...state.feeds];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      feeds.clear();
      if(uncompletedFeeds.isNotEmpty) {
        newItems = <FeedModel>[...uncompletedFeeds, ...newItems];
      }
    }
    feeds.addAll(newItems);

    emit(state.copyWith(status: FeedStatus.fetchFeedsSuccessful,
        feeds: feeds,
        data: { "pageKey": pageKey }
    ));

    return (null, newItems);
  }


  /// Like / unlike post
  /// actions - ["add", "remove"]
  Future<void> togglePostLikeAction({required FeedModel feed, required String action}) async {

    final existingFeed = feed;


    // next thing is you need to broadcast so that every cubit with this post will know you have liked it
    addLike() {
      final updatedFeed = feed.copyWith(
          totalLikes: (feed.totalLikes ?? 0) + 1,
          hasLiked: (feed.hasLiked ?? 0) + 1
      );
      feedBroadcastRepository.updateFeed(feed: updatedFeed);
      emit(state.copyWith(status: FeedStatus.togglePostLikeActionSuccessful));
    }

    removeLike() {
      final updatedFeed = feed.copyWith(
          totalLikes: (feed.totalLikes ?? 1) - (feed.hasLiked ?? 1), // reduce total likes by the number of times this user has liked
          hasLiked: 0 // reduce all likes to zero once user removes the likes
      );
      feedBroadcastRepository.updateFeed(feed: updatedFeed);
      emit(state.copyWith(status: FeedStatus.togglePostLikeActionSuccessful));
    }

    failed(String reason) {
      //update with existing feed
      feedBroadcastRepository.updateFeed(feed: existingFeed);
      emit(state.copyWith(status: FeedStatus.togglePostLikeActionFailed, message: reason));
    }


    emit(state.copyWith(status: FeedStatus.togglePostLikeActionInProgress));
    //optimistic update feed
    if(action == "add") {
      addLike();
    }else {
      removeLike();
    }

    final either = await feedsRepository.togglePostLikeAction(postId: feed.id, action: action);
    if(either.isLeft()){
      final l = either.asLeft();
      failed(l);
      return;
    }


    // once its successful do nothing

  }

  /// bookmark / unBookmark post
  Future<void> togglePostBookmarkAction({required FeedModel feed}) async {

    final existingFeed = feed;

    changeBookmark(bool status) {
      final updatedFeed = feed.copyWith(
          hasBookmarked: status,
          totalBookmarks: status ? ((existingFeed.totalBookmarks ?? 0) + 1) : ((existingFeed.totalBookmarks ?? 1) - 1)
      );
      feedBroadcastRepository.updateFeed(feed: updatedFeed);
      emit(state.copyWith(status: FeedStatus.togglePostBookmarkActionSuccessful, data: {"feed": updatedFeed} ));
    }

    failed(String reason) {
      feedBroadcastRepository.updateFeed(feed: existingFeed);
      emit(state.copyWith(status: FeedStatus.togglePostBookmarkActionFailed, message: reason));
    }

    emit(state.copyWith(status: FeedStatus.togglePostBookmarkActionInProgress));
    changeBookmark(!(existingFeed.hasBookmarked ?? false)); // toggle bookmark

    final either = await feedsRepository.togglePostBookmarkAction(postId: feed.id);
    if(either.isLeft()){
      final l = either.asLeft();
      failed(l);
      return;
    }

    // do nothing if its successful

  }

  /// report post
  Future<void> reportPost({required int? postId, required String reason}) async {

    failed(String message) {
      emit(state.copyWith(status: FeedStatus.reportPostFailed, message: message));
    }


    emit(state.copyWith(status: FeedStatus.reportPostInProgress));

    // once user is connected to the network, just assume post is successful
    if(!(await isNetworkConnected())) {
      failed("You're not connected to the internet");
      return;
    }

    emit(state.copyWith(status: FeedStatus.reportPostSuccessful));
    final either = await feedsRepository.reportPost(postId: postId, reason: reason);
    if(either.isLeft()){
      final l = either.asLeft();
      failed(l);
      return;
    }

    // successful do nothing

  }

  /// view post
  /// actions -> ['seen', 'watched']
  Future<void> viewPost({required int? postId, required String action}) async {

    failed(String reason) {
      emit(state.copyWith(status: FeedStatus.viewPostFailed, message: reason));
    }

    emit(state.copyWith(status: FeedStatus.viewPostActionInProgress));

    final either = await feedsRepository.viewPost(postId: postId, action: action);
    if(either.isLeft()){
      final l = either.asLeft();

      return;
    }

    emit(state.copyWith(status: FeedStatus.viewPostActionSuccessful));

  }

  void deletePost({required FeedModel post}) async {

    failed(String message) {
      emit(state.copyWith(status: FeedStatus.deletePostFailed, message: message));
    }

    emit(state.copyWith(status: FeedStatus.deletePostInProgress));

    // once user is connected to the network, just assume post is successful
    if(!(await isNetworkConnected())) {
      failed("You're not connected to the internet");
      return;
    }

    // final feeds = <FeedModel>[...state.feeds];
    // final indexOfFeed = feeds.indexWhere((element) => element.id == postId);
    // if(indexOfFeed > -1) {
    //   // feeds[indexOfFeed] = feeds[indexOfFeed].
    //   feeds.removeAt(indexOfFeed);
    // }
    //
    // refreshList(updatedFeeds: feeds);
    feedBroadcastRepository.deleteFeed(feed: post);
    emit(state.copyWith(status: FeedStatus.deletePostSuccessful,));
    final either = await feedsRepository.deletePost(postId: post.id);
    if(either.isLeft()){
      final l = either.asLeft();
      failed(l);
      return;
    }

  }

  void refreshList({List<FeedModel>? updatedFeeds}) {
    emit(state.copyWith(status: FeedStatus.refreshListInProgress));
    emit(state.copyWith(status: FeedStatus.refreshListCompleted, feeds: updatedFeeds ?? state.feeds));
  }


}