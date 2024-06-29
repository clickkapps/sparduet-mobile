import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/home/data/store/enums.dart';
import 'package:sparkduet/features/home/data/store/nav_state.dart';

class NavCubit extends Cubit<NavState> {

  NavCubit(): super(const NavState());

  void onTabChange(int index){
    emit(state.copyWith(status: NavStatus.onTabChangedInProgress));
    emit(state.copyWith(previousIndex: state.currentTabIndex, currentTabIndex: index,
        status: NavStatus.onTabChanged
    ));
  }

  void requestTabChange(int index) {
    emit(state.copyWith(status: NavStatus.onTabChangeRequestedInProgress));
    emit(state.copyWith(previousIndex: state.currentTabIndex, currentTabIndex: index, status: NavStatus.onTabChangeRequested));
  }

  void onActiveIndexTapped(int index) {
    emit(state.copyWith(status: NavStatus.onActiveIndexTappedInProgress));
    emit(state.copyWith(status: NavStatus.onActiveIndexTappedCompleted, data: index));
  }

}