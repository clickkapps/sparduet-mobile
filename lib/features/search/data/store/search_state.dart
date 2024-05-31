import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/search/data/store/enums.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

part 'search_state.g.dart';

@CopyWith()
class SearchState extends Equatable {
  final SearchStatus status;
  final String? message;
  final (List<UserModel>, List<FeedModel>) topSearch;
  final List<UserModel> users;
  final List<FeedModel> stories;
  final List<String> popularSearch;
  final List<String> recentSearch;

  const SearchState({
    this.status = SearchStatus.initial,
    this.message,
    this.topSearch = (const [], const []),
    this.users = const [],
    this.stories = const [],
    this.popularSearch = const [],
    this.recentSearch = const []
  });

  @override
  List<Object?> get props => [status, message];

}