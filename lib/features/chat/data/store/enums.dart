enum ChatConnectionStatus {
  initial, fetchSuggestedChatUsersLoading, fetchSuggestedChatUsersError, fetchSuggestedChatUsersSuccessful, createChatConnectionLoading, createChatConnectionError, createChatConnectionSuccessful, fetchChatConnectionLoading, refreshChatConnectionsCompleted, fetchChatConnectionError
}

enum ChatPreviewStatus {
  initial, refreshChatMessagesSuccessful, fetchChatMessagesInProgress
}

enum ChatBroadcastAction {
  addMessage, updateMessage, deleteMessage
}