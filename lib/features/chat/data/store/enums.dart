enum ChatConnectionStatus {
  initial, fetchSuggestedChatUsersLoading, fetchSuggestedChatUsersError, fetchSuggestedChatUsersSuccessful, createChatConnectionLoading, createChatConnectionError, createChatConnectionSuccessful, fetchChatConnectionLoading, refreshChatConnectionsCompleted, fetchChatConnectionError
}

enum ChatPreviewStatus {
  initial
}

enum ChatBroadcastAction {
  addMessage, updateMessage, deleteMessage
}