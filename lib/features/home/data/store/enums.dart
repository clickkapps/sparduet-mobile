enum NavStatus {
  initial, onTabChanged, onTabChangeRequested, onTabChangedInProgress, onTabChangeRequestedInProgress, onTapExistigTab, onActiveIndexTappedInProgress, onActiveIndexTappedCompleted
}

enum HomeStatus {
  initial, didPushToNextInProgress, didPushToNextCompleted, didPopFromNextInProgress, didPopFromNextCompleted
}

enum HomeBroadcastAction {
  realtimeServerNotification
}