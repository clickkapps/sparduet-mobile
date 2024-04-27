import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/data/models/feed_broadcast_event.dart';
import 'package:sparkduet/features/feeds/data/models/post_feed_request.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_repository.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/files/data/models/media_model.dart';
import 'package:sparkduet/features/files/data/repositories/file_repository.dart';
import 'package:sparkduet/features/files/data/store/enums.dart';

class FeedCubit extends Cubit<FeedState> {

  final FeedRepository feedRepository;
  final FileRepository fileRepository;
  final FeedBroadcastRepository feedBroadcastRepository;
  StreamSubscription<FeedBroadCastEvent>? feedBroadcastRepositoryStreamListener;
  FeedCubit(this.fileRepository, {required this.feedRepository, required this.feedBroadcastRepository}): super(const FeedState()) {
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

  /// Create a new feed // This is automatically triggered by [postPayloadPart] or [postFilePart]
  void _postFeed({String? purpose, MediaModel? media, String? description, bool commentsDisabled = false}) async {

    // check if feed is up

    emit(state.copyWith(status: FeedStatus.postFeedInProgress));

    final either = await feedRepository.postFeed(purpose: purpose, media: media, description: description, commentsDisabled: commentsDisabled);
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(state.copyWith(status: FeedStatus.postFeedFailed, message: l));
      return;
    }

    emit(state.copyWith(status: FeedStatus.postFeedSuccessful));

  }

  void postPayloadPart({required String id, String? purpose, String? description, bool commentsDisabled = false}) async {
    emit(state.copyWith(postFeedRequest: state.postFeedRequest.copyWith(mediaParts: state.postFeedRequest.payloadParts..add(
        {
          "id": id,
          "status": "success",
          "payload": {
            "purpose": purpose,
            "description": description,
            "commentsDisabled": commentsDisabled
          }
        }))));

    // check if postRequest has a successful mediaParts entry with status of success and same id
    final indexOfSuccessMediaPart = state.postFeedRequest.mediaParts.indexWhere((element) => element["id"] == id && element["status"] == "success");
    if(indexOfSuccessMediaPart < 0) {
      return;
    }

    final data = state.postFeedRequest.mediaParts[indexOfSuccessMediaPart];
    _postFeed(
        purpose: purpose,
        description: description,
        commentsDisabled: commentsDisabled,
        media: data["media"] as MediaModel
    );
  }

  // this methods upload the video / image file of the post feed.
  void postFilePart({required String id, required File file, required MediaType mediaType}) async {
    //

    // add entery with status of pending
    emit(state.copyWith(postFeedRequest: state.postFeedRequest.copyWith(mediaParts: state.postFeedRequest.mediaParts..add(
        {"id": id, "status": "pending"}))));
    //
    emit(state.copyWith(status: FeedStatus.uploadFeedFileInProgress));
    final either = await fileRepository.uploadFileToCloudinary(files: [file]);

    if(either.isLeft()){
      final l = either.asLeft();
      final List<Map<String, dynamic>> mediaParts = state.postFeedRequest.mediaParts;
      final mediaPartIndex = mediaParts.indexWhere((element) => element["id"] == id);
      final mediaPart = mediaParts[mediaPartIndex];
      mediaPart["status"] = "failed";
      mediaPart["message"] = l;
      mediaParts[mediaPartIndex] = mediaPart;
      emit(state.copyWith(status: FeedStatus.uploadFeedFileFailed, postFeedRequest: state.postFeedRequest.copyWith(mediaParts: mediaParts)));

      return;
    }

    final r = either.asRight();
    final List<Map<String, dynamic>> mediaParts = state.postFeedRequest.mediaParts;
    final mediaPartIndex = mediaParts.indexWhere((element) => element["id"] == id);
    final mediaPart = mediaParts[mediaPartIndex];
    final media = MediaModel(path: r, type: mediaType);
    mediaPart["status"] = "success";
    mediaPart["media"] = media;
    mediaParts[mediaPartIndex] = mediaPart;
    emit(state.copyWith(status: FeedStatus.uploadFeedFileSuccess, postFeedRequest: state.postFeedRequest.copyWith(mediaParts: mediaParts)));

    // check if postRequest has a successful payloadParts entry with status of success and same id
    final indexOfSuccessPayloadPart = state.postFeedRequest.payloadParts.indexWhere((element) => element["id"] == id && element["status"] == "success");
    if(indexOfSuccessPayloadPart < 0) {
      return;
    }

    final data = state.postFeedRequest.payloadParts[indexOfSuccessPayloadPart];
    _postFeed(
      purpose: data["payload"]["purpose"],
      description: data["payload"]["description"],
      commentsDisabled: data["payload"]["commentsDisabled"],
      media: media
    );

  }

}