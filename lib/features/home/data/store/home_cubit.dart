import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/home/data/repositories/home_broadcast_repository.dart';
import 'package:sparkduet/features/home/data/store/home_state.dart';
import '../repositories/socket_connection_repository.dart';

class HomeCubit extends Cubit<HomeState> {

  SocketConnectionRepository socketConnectionRepository;
  HomeBroadcastRepository homeBroadcastRepository;
  HomeCubit({required this.socketConnectionRepository, required this.homeBroadcastRepository}): super(const HomeState());

  Future<void> initializeSocketConnection() async {
    await socketConnectionRepository.createAblyRealtimeInstance();
    // await socketConnectionRepository.getWebSocketConnection(onEvent: (event) {
    //   debugPrint("Pusher: server event received: $event");
    //   homeBroadcastRepository.realtimeServerNotificationReceived(channelId: event.channelName, data: json.decode(event.data));
    // });

  }

  @override
  Future<void> close() {
    socketConnectionRepository.realtimeInstance?.close();
    return super.close();
  }

}