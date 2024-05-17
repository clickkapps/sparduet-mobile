enum FeedStatus {
  initial, postFeedInProgress, postFeedFailed, postFeedSuccessful, uploadFeedFileInProgress, uploadFeedFileFailed, uploadFeedFileSuccess, fetchFeedsInProgress, fetchFeedsFailed, fetchFeedsSuccessful, unCompletedPostsWithFeeds, setFeedCompleted, setFeedInProgress
}

enum FeedBroadcastAction {
  add, update, delete
}