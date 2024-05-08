import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/home/data/enums.dart';
import 'package:sparkduet/features/home/data/nav_state.dart';

class NavCubit extends Cubit<NavState> {

  NavCubit(): super(const NavState());

  void onTabChange(int index){
    emit(state.copyWith(previousIndex: state.currentTabIndex, currentTabIndex: index,
        status: NavStatus.onTabChanged
    ));
  }

  void requestTabChange(int index) {
    emit(state.copyWith(previousIndex: state.currentTabIndex, currentTabIndex: index, status: NavStatus.onTabChangeRequested));
  }

}