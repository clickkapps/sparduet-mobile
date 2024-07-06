import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/feeds/data/repositories/feed_broadcast_repository.dart';
import 'package:sparkduet/features/home/data/repositories/home_broadcast_repository.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/home/data/store/home_state.dart';
import '../repositories/socket_connection_repository.dart';

class HomeCubit extends Cubit<HomeState> {

  SocketConnectionRepository socketConnectionRepository;
  HomeBroadcastRepository homeBroadcastRepository;
  FeedBroadcastRepository feedBroadcastRepository;
  HomeCubit({required this.socketConnectionRepository, required this.homeBroadcastRepository, required this.feedBroadcastRepository}): super(const HomeState());

  Future<void> initializeSocketConnection() async {
    await socketConnectionRepository.createAblyRealtimeInstance();
    // await socketConnectionRepository.getWebSocketConnection(onEvent: (event) {
    //   debugPrint("Pusher: server event received: $event");
    //   homeBroadcastRepository.realtimeServerNotificationReceived(channelId: event.channelName, data: json.decode(event.data));
    // });
    final channel = socketConnectionRepository.realtimeInstance?.channels.get("public:stories.disciplinary-record-updated");
    channel?.subscribe().listen((event) {
      final data = event.data as Map<Object?, Object?>;
      final json = convertMap(data);
      final feedId = json['storyId'] as int?;
      final action = json['disAction'] as String?;
      feedBroadcastRepository.updateFeedCensorship(feedId: feedId, disAction: action);
    });

  }

  @override
  Future<void> close() {
    socketConnectionRepository.realtimeInstance?.close();
    return super.close();
  }


  void didPushToNext({required int tabIndex }) {
    emit(state.copyWith(status: HomeStatus.didPushToNextInProgress));
    emit(state.copyWith(status: HomeStatus.didPushToNextCompleted, data: { "tabIndex": tabIndex }));
  }

  void didPopFromNext({required int tabIndex}) {
    emit(state.copyWith(status: HomeStatus.didPopFromNextInProgress));
    emit(state.copyWith(status: HomeStatus.didPopFromNextCompleted, data: { "tabIndex": tabIndex }));
  }

}