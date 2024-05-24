import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/search/data/store/enums.dart';

part 'search_state.g.dart';

@CopyWith()
class SearchState extends Equatable {
  final SearchStatus status;
  final String? message;

  const SearchState({
    this.status = SearchStatus.initial,
    this.message
  });

  @override
  List<Object?> get props => [status, message];

}