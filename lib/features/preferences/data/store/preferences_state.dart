import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/preferences/data/store/enums.dart';

part 'preferences_state.g.dart';

@CopyWith()
class PreferencesState extends Equatable {
  final PreferencesStatus status;
  final String? message;
  final bool enableChatNotifications;
  final bool enableProfileViewsNotifications;
  final bool enableStoryViewsNotifications;
  final bool enableStoryLikesNotifications;
  final String preferredThemeAppearance;
  final String? preferredFontFamily;
  final bool? showSwipeUpStoriesHint;

  const PreferencesState({
    this.status = PreferencesStatus.initial,
    this.enableChatNotifications = true,
    this.enableProfileViewsNotifications = true,
    this.enableStoryLikesNotifications = true,
    this.enableStoryViewsNotifications = true,
    this.showSwipeUpStoriesHint = false,
    this.preferredFontFamily,
    this.preferredThemeAppearance = "light",
    this.message
  });

  @override
  List<Object?> get props => [status, message];
}