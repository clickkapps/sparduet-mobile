import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  final String? countryCode;
  final String? countryName;

  const CountryModel({this.countryCode, this.countryName});

  @override
  List<Object?> get props => [countryCode, countryName];
}