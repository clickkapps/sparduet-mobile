import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/preferences/data/repositories/preferences_repository.dart';
import 'package:sparkduet/features/preferences/data/store/enums.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_state.dart';

class PreferencesCubit extends Cubit<PreferencesState> {

  final PreferencesRepository preferencesRepository;
  PreferencesCubit({required this.preferencesRepository}): super(const PreferencesState());


  void saveSettings({required Map<String, dynamic> args}) {

    emit(state.copyWith(status: PreferencesStatus.saveSettingsInProgress));
    emit(state.copyWith(status: PreferencesStatus.saveSettingsCompleted,
        enableChatNotifications: args.containsKey("enable_chat_notifications") ? (args["enable_chat_notifications"] as int) == 1 : state.enableChatNotifications,
        enableProfileViewsNotifications: args.containsKey("enable_profile_views_notifications") ? (args["enable_profile_views_notifications"] as int) == 1 : state.enableProfileViewsNotifications,
        enableStoryViewsNotifications: args.containsKey("enable_story_views_notifications") ? (args["enable_story_views_notifications"] as int) == 1 : state.enableStoryViewsNotifications,
        preferredThemeAppearance: args.containsKey("theme_appearance") ? args['theme_appearance'] as String? : state.preferredThemeAppearance,
        preferredFontFamily: args.containsKey("font_family") ? args['font_family'] as String? : state.preferredFontFamily
    ));
  }


  void fetchUserSettings() async {

    emit(state.copyWith(status: PreferencesStatus.fetchUserSettingsInProgress));
    final either = await preferencesRepository.fetchUserSettings();
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: PreferencesStatus.fetchUserSettingsFailed, message: l));
      return;
    }

    final r = either.asRight();
    saveSettings(args: r);
    emit(state.copyWith(status: PreferencesStatus.fetchUserSettingsSuccessful,));

  }

  void updateUserSettings({required Map<String, dynamic> payload}) async {

    final prevState = state.copyWith();

    saveSettings(args: payload);

    emit(state.copyWith(status: PreferencesStatus.updateUserSettingsInProgress));
    final either = await preferencesRepository.updateUserSettings(payload: payload);
    if(either.isLeft()) {
      final l = either.asLeft();
      emit(prevState.copyWith(status: PreferencesStatus.updateUserSettingsFailed, message: l));
      return;
    }

    // final r = either.asRight();
    // saveSettings(args: r);
    emit(state.copyWith(status: PreferencesStatus.updateUserSettingsSuccessful));

  }

  // create feedback -----------
  void createFeedback({required String message}) async {

    failed(String message) {
      emit(state.copyWith(status: PreferencesStatus.createFeedbackFailed, message: message));
    }


    emit(state.copyWith(status: PreferencesStatus.createFeedbackInProgress));

    // once user is connected to the network, just assume post is successful
    if(!(await isNetworkConnected())) {
      failed("You're not connected to the internet");
      return;
    }

    emit(state.copyWith(status: PreferencesStatus.createFeedbackSuccessful));
    final either = await preferencesRepository.createFeedback( message: message);
    if(either.isLeft()){
      final l = either.asLeft();
      failed(l);
      return;
    }

    // successful do nothing

  }

}