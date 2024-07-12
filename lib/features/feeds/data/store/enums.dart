enum FeedStatus {
  initial, postFeedInProgress, postFeedFailed, postFeedSuccessful, uploadFeedFileInProgress, uploadFeedFileFailed, uploadFeedFileSuccess, fetchFeedsInProgress, fetchFeedsFailed, fetchFeedsSuccessful, unCompletedPostsWithFeeds, setFeedCompleted, setFeedInProgress, postFeedProcessFileInProgress, postFeedProcessFileFailed,
   postFeedProcessFileCompleted, togglePostLikeActionInProgress, togglePostLikeActionFailed, togglePostBookmarkActionInProgress, togglePostBookmarkActionFailed, reportPostInProgress, reportPostFailed, viewPostActionInProgress, viewPostFailed, togglePostLikeActionSuccessful, togglePostBookmarkActionSuccessful, reportPostSuccessful, viewPostActionSuccessful,
  updateFeedCompleted, deleteFeedCompleted, feedBroadcastActionInProgress, deletePostFailed, deletePostInProgress, deletePostSuccessful, refreshListInProgress, refreshListCompleted, setBackgroundHasRefreshedFeedInProgress, setBackgroundHasRefreshedFeedCompleted, deleteTempPostFailed, deleteTempPostInProgress, deleteTempPostSuccessful
}

enum FeedBroadcastAction {
  add, update, delete, deleteTempPost, censorUpdated
}