enum FeedStatus {
  initial, postFeedInProgress, postFeedFailed, postFeedSuccessful, uploadFeedFileInProgress, uploadFeedFileFailed, uploadFeedFileSuccess, fetchFeedsInProgress, fetchFeedsFailed, fetchFeedsSuccessful, unCompletedPostsWithFeeds, setFeedCompleted, setFeedInProgress, postFeedProcessFileInProgress, postFeedProcessFileFailed,
   postFeedProcessFileCompleted
}

enum FeedBroadcastAction {
  add, update, delete
}