import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/features/search/data/repositories/search_repository.dart';
import 'package:sparkduet/features/search/data/store/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;
  SearchCubit({required this.searchRepository}): super(const SearchState());
}