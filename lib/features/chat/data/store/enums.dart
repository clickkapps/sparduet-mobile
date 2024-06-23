enum ChatConnectionStatus {
  initial, fetchSuggestedChatUsersLoading, fetchSuggestedChatUsersError, fetchSuggestedChatUsersSuccessful, createChatConnectionLoading, createChatConnectionError, createChatConnectionSuccessful, fetchChatConnectionLoading, refreshChatConnectionsCompleted, fetchChatConnectionError, fetchingChatConnectionsFromMemory, lastMessageUpdatedInProgress, updateChatConnectionUnreadMessagesCountInProgress
}

enum ChatPreviewStatus {
  initial, refreshChatMessagesSuccessful, fetchChatMessagesInProgress, sendMessageLoading, sendMessageFailed, sendMessageSuccessful, addNewMessageInProgress, addNewMessageCompleted, refreshChatMessagesInProgress, updateMessageInProgress, updateMessageCompleted, deleteMessageInProgress, deleteMessageCompleted, fetchChatMessagesSuccessful, fetchChatMessagesError, updateFirstImpressionMessageReadCompleted, setSelectedChatConnectionInProgress, setSelectedChatConnectionCompleted, refreshChatConnectionsCompleted, markMessagesAsReadInProgress, markMessagesAsReadFailed, markMessagesAsReadSuccessful
}

enum ChatBroadcastAction {
   updateLastMessage, updateUnreadMessagesCount
}