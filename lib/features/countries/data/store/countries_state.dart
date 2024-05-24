import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:sparkduet/features/countries/data/models/country_model.dart';
import 'package:sparkduet/features/countries/data/store/enums.dart';

part 'countries_state.g.dart';

@CopyWith()
class CountriesState extends Equatable {
  final CountryStatus status;
  final String? message;
  final List<CountryModel> countries;
  final List<CountryModel> filteredCountries;

  const CountriesState({
    this.status = CountryStatus.initial,
    this.message,
    this.countries = const [],
    this.filteredCountries = const []
  });

  @override
  List<Object?> get props => [status, message];

}