import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
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

      emit(state.copyWith(status: FeedStatus.postFeedInProgress, feeds: existingFeeds));
    }

    void updatePostId(int postId) {
      final existingFeeds = <FeedModel>[...state.feeds];
      final existingTempFeedIndex = existingFeeds.indexWhere((element) => element.tempId == postTempId);
      if(existingTempFeedIndex > -1) {
        existingFeeds[existingTempFeedIndex] = existingFeeds[existingTempFeedIndex].copyWith(
          id: postId,
          status: null
        );
      }
      emit(state.copyWith(status: FeedStatus.postFeedSuccessful, feeds: existingFeeds));
    }

    ///! function to set post as failed
    void setError(String error) {
      final existingFeeds = <FeedModel>[...state.feeds];
      final postIndex = existingFeeds.indexWhere((element) => element.tempId == postTempId);
      existingFeeds[postIndex] = existingFeeds[postIndex].copyWith(status: "failed");
      emit(state.copyWith(status: FeedStatus.postFeedFailed, message: error, feeds: existingFeeds));
    }

    ///! set Post as successful
    void setCompleted(FeedModel feed) {
      final existingFeeds = <FeedModel>[...state.feeds];
      final postIndex = existingFeeds.indexWhere((element) => element.tempId == postTempId);
      existingFeeds[postIndex] = feed;
      emit(state.copyWith(status: FeedStatus.postFeedProcessFileCompleted, feeds: existingFeeds, data: feed));
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


    File? postFile;
    FileType? postMediaType;
    emit(state.copyWith(status: FeedStatus.postFeedProcessFileInProgress));


    //! Flip file if its front camera
    if(flipFile) {
      postFile = await AppPostConverter.flipVideo(file);
    }

    // convert image to music
    if(mediaType == FileType.image) {
      postFile = await AppPostConverter.convertImageToVideoWithMusic(file.path, "https://d2e46virtl8cds.cloudfront.net/track_1.mp3");
      if(postFile == null) {
        setError("Unable to convert image to video");
      }
    }

    // start upload
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
    final media =  MediaModel(path: filePath, type: postMediaType ?? mediaType, assetId: assetId, aspectRatio: aspectRatio);

    // attach media file to server
    final attachMediaResponse = await feedsRepository.attachMediaToPost(postId: initialPostId, media: media);
    if(attachMediaResponse.isLeft()) {
      final l = attachMediaResponse.asLeft();
      setError(l);
      return;
    }

    final completedPost = attachMediaResponse.asRight();
    setCompleted(completedPost);


  }


  //! Fetch feeds and update the app's state as well as the UI
  Future<(String?, List<FeedModel>?)> fetchFeeds({required String path, required int pageKey, Map<String, dynamic>? queryParams}) async {


    final uncompletedFeeds = state.feeds.where((element) => element.id == null).toList();
    if(uncompletedFeeds.isNotEmpty && pageKey == 1) {
      emit(state.copyWith(status: FeedStatus.fetchFeedsInProgress));
      emit(state.copyWith(status: FeedStatus.unCompletedPostsWithFeeds, feeds: state.feeds));
    }

    emit(state.copyWith(status: FeedStatus.fetchFeedsInProgress));
    final either = await feedsRepository.fetchFeeds(path, queryParams: queryParams);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: FeedStatus.fetchFeedsFailed, message: l));
      return (l, null);
    }

    final newItems = either.asRight();
    final List<FeedModel> feeds = <FeedModel>[...state.feeds];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      feeds.clear();
      feeds.addAll(uncompletedFeeds);
    }
    feeds.addAll(newItems);

    emit(state.copyWith(status: FeedStatus.fetchFeedsSuccessful,
        feeds: feeds
    ));

    return (null, newItems);
  }


}