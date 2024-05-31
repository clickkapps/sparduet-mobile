import 'package:flutter/material.dart';
import 'package:sparkduet/features/countries/data/models/country_model.dart';

class SelectedCountryItemWidget extends StatelessWidget {

  final CountryModel country;
  final Function()? onTap;
  const SelectedCountryItemWidget({super.key, required this.country, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(4)
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(country.countryName ?? "", style: const TextStyle(fontSize: 12),),
            const SizedBox(width: 5,),
            const Icon(Icons.check_circle, size: 16, color: Colors.green,)
          ],
        ),
      ),
    );
  }
}
