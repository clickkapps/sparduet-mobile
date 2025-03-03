import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';

part 'nav_state.g.dart';

@CopyWith()
class NavState extends Equatable {

  final NavStatus status;
  final String? message;
  final int previousIndex;
  final int currentTabIndex;
  final int? requestedTabIndex;
  final dynamic data;

  const NavState({this.status = NavStatus.initial, this.message, this.data, this.currentTabIndex = 0, this.previousIndex = 0, this.requestedTabIndex});

  @override
  List<Object?> get props => [status, currentTabIndex];

}