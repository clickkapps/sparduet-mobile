// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SearchStateCWProxy {
  SearchState status(SearchStatus status);

  SearchState message(String? message);

  SearchState topSearch((List<UserModel>, List<FeedModel>) topSearch);

  SearchState users(List<UserModel> users);

  SearchState stories(List<FeedModel> stories);

  SearchState popularSearch(List<String> popularSearch);

  SearchState recentSearch(List<String> recentSearch);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SearchState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SearchState(...).copyWith(id: 12, name: "My name")
  /// ````
  SearchState call({
    SearchStatus? status,
    String? message,
    (List<UserModel>, List<FeedModel>)? topSearch,
    List<UserModel>? users,
    List<FeedModel>? stories,
    List<String>? popularSearch,
    List<String>? recentSearch,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSearchState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSearchState.copyWith.fieldName(...)`
class _$SearchStateCWProxyImpl implements _$SearchStateCWProxy {
  const _$SearchStateCWProxyImpl(this._value);

  final SearchState _value;

  @override
  SearchState status(SearchStatus status) => this(status: status);

  @override
  SearchState message(String? message) => this(message: message);

  @override
  SearchState topSearch((List<UserModel>, List<FeedModel>) topSearch) =>
      this(topSearch: topSearch);

  @override
  SearchState users(List<UserModel> users) => this(users: users);

  @override
  SearchState stories(List<FeedModel> stories) => this(stories: stories);

  @override
  SearchState popularSearch(List<String> popularSearch) =>
      this(popularSearch: popularSearch);

  @override
  SearchState recentSearch(List<String> recentSearch) =>
      this(recentSearch: recentSearch);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SearchState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SearchState(...).copyWith(id: 12, name: "My name")
  /// ````
  SearchState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? topSearch = const $CopyWithPlaceholder(),
    Object? users = const $CopyWithPlaceholder(),
    Object? stories = const $CopyWithPlaceholder(),
    Object? popularSearch = const $CopyWithPlaceholder(),
    Object? recentSearch = const $CopyWithPlaceholder(),
  }) {
    return SearchState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as SearchStatus,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      topSearch: topSearch == const $CopyWithPlaceholder() || topSearch == null
          ? _value.topSearch
          // ignore: cast_nullable_to_non_nullable
          : topSearch as (List<UserModel>, List<FeedModel>),
      users: users == const $CopyWithPlaceholder() || users == null
          ? _value.users
          // ignore: cast_nullable_to_non_nullable
          : users as List<UserModel>,
      stories: stories == const $CopyWithPlaceholder() || stories == null
          ? _value.stories
          // ignore: cast_nullable_to_non_nullable
          : stories as List<FeedModel>,
      popularSearch:
          popularSearch == const $CopyWithPlaceholder() || popularSearch == null
              ? _value.popularSearch
              // ignore: cast_nullable_to_non_nullable
              : popularSearch as List<String>,
      recentSearch:
          recentSearch == const $CopyWithPlaceholder() || recentSearch == null
              ? _value.recentSearch
              // ignore: cast_nullable_to_non_nullable
              : recentSearch as List<String>,
    );
  }
}

extension $SearchStateCopyWith on SearchState {
  /// Returns a callable class that can be used as follows: `instanceOfSearchState.copyWith(...)` or like so:`instanceOfSearchState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SearchStateCWProxy get copyWith => _$SearchStateCWProxyImpl(this);
}
