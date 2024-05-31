import 'package:dartz/dartz.dart';
import 'package:sparkduet/features/countries/data/models/country_model.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/network/network_provider.dart';

class CountriesRepository {
  final NetworkProvider networkProvider;
  const CountriesRepository({required this.networkProvider});

  Future<Either<String, List<CountryModel>>> fetchCountries() async {

    try{

      const path = AppApiRoutes.getCountries;

      final response = await networkProvider.call(
          path: path,
          method: RequestMethod.get,
      );

      if (response!.statusCode == 200) {

        final dynamicDataMap = response.data['data'] as Map<String, dynamic>;
        final list = List<CountryModel>.from(dynamicDataMap.entries.map((x) {
          // final map = x as Map<String, dynamic>;
          final countryCode = x.key;
          final value  = x.value as Map<String, dynamic>;
          final countryName = value['country'] as String;
          return CountryModel(
            countryCode: countryCode,
            countryName: countryName
        );
        }));
        return Right(list);

      } else {
        return Left(response.statusMessage ?? "");
      }



    }catch(e) {
      return Left(e.toString());
    }

  }

}