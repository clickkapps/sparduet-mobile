import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/countries/data/store/countries_state.dart';
import 'package:sparkduet/features/countries/data/store/enums.dart';
import '../repositories/countries_repository.dart';

class CountriesCubit  extends Cubit<CountriesState> {
  final CountriesRepository countriesRepository;
  CountriesCubit({required this.countriesRepository}): super(const CountriesState());


  void fetchAllCountries() async {
    emit(state.copyWith(status: CountryStatus.fetchAllCountriesInProgress));

    if(state.countries.isNotEmpty) {
      emit(state.copyWith(status: CountryStatus.fetchAllCountriesSuccessful));
      return;
    }

    final either = await countriesRepository.fetchCountries();

    if(either.isLeft()) {
      emit(state.copyWith(status: CountryStatus.fetchAllCountriesFailed, message: either.asLeft()));
      return;
    }

    final r = either.asRight();
    emit(state.copyWith(
      status: CountryStatus.fetchAllCountriesSuccessful,
      countries: r
    ));

  }

}