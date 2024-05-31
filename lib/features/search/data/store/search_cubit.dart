import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/search/data/repositories/search_repository.dart';
import 'package:sparkduet/features/search/data/store/enums.dart';
import 'package:sparkduet/features/search/data/store/search_state.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;
  SearchCubit({required this.searchRepository}): super(const SearchState());

  void topSearch({String? query, int? authUserId}) async {

    emit(state.copyWith(status: SearchStatus.topSearchInProgress));
    final either = await searchRepository.topSearch(query: query);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: SearchStatus.topSearchFailed, message: l));
      return;
    }

    final r = either.asRight();
    emit(state.copyWith(status: SearchStatus.topSearchSuccessful,
      topSearch: (r.$1.where((element) => element.id != authUserId).toList(), r.$2)
    ));

  }

  Future<(String?, List<UserModel>?)> searchUsers({String? query, int? pageKey, int? authUserId}) async {
    emit(state.copyWith(status: SearchStatus.searchUsersInProgress));
    final either = await searchRepository.searchUsers(query: query, pageKey: pageKey);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: SearchStatus.searchUsersFailed, message: l));
      return (l, null);
    }


    final newItems = either.asRight().where((element) => element.id != authUserId).toList();
    final List<UserModel> users = <UserModel>[...state.users];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      users.clear();
    }
    users.addAll(newItems);
    emit(state.copyWith(status: SearchStatus.searchUsersSuccessful, users: users));
    return (null, newItems);
  }

  Future<(String?, List<FeedModel>?)> searchStories({String? query, int? pageKey}) async {

    emit(state.copyWith(status: SearchStatus.searchStoriesInProgress));
    final either = await searchRepository.searchStories(query: query, pageKey: pageKey);
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: SearchStatus.searchStoriesFailed, message: l));
      return (l, null);
    }


    final newItems = either.asRight();
    final List<FeedModel> stories = <FeedModel>[...state.stories];
    if(pageKey == 1){
      // if its first page request remove all existing threads
      stories.clear();
    }
    stories.addAll(newItems);
    emit(state.copyWith(status: SearchStatus.searchStoriesSuccessful, stories: stories));
    return (null, newItems);

  }

  void fetchPopularSearchTerms() async {


    // return what's in local memory if any
    if(state.popularSearch.isNotEmpty){
      emit(state.copyWith(status: SearchStatus.popularSearchTermsProgress));
      emit(state.copyWith(status: SearchStatus.popularSearchTermsSuccessful,));
    }

    emit(state.copyWith(status: SearchStatus.popularSearchTermsProgress));
    final either = await searchRepository.popularSearchTerms();
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: SearchStatus.popularSearchTermsFailed, message: l));
      return;
    }

    final r = either.asRight();
    emit(state.copyWith(status: SearchStatus.popularSearchTermsSuccessful,
        popularSearch: r
    ));
  }

  void fetchRecentSearchTerms() async {

    // just return what's in local memory
    if(state.recentSearch.isNotEmpty){
      emit(state.copyWith(status: SearchStatus.recentSearchTermsProgress));
      emit(state.copyWith(status: SearchStatus.recentSearchTermsSuccessful,));
    }

    emit(state.copyWith(status: SearchStatus.recentSearchTermsProgress));
    final either = await searchRepository.recentSearchTerms();
    if(either.isLeft()){
      final l = either.asLeft();
      emit(state.copyWith(status: SearchStatus.recentSearchTermsFailed, message: l));
      return;
    }

    final r = either.asRight();
    emit(state.copyWith(status: SearchStatus.recentSearchTermsSuccessful,
        recentSearch: r
    ));

  }

}