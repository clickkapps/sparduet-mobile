import 'package:sparkduet/features/home/data/store/enums.dart';

class HomeBroadcastEvent {
  final HomeBroadcastAction action;
  final String? identifier;
  final dynamic data;
  const HomeBroadcastEvent({required this.action, this.identifier, this.data});
}