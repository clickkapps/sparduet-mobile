import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/countries/data/models/country_model.dart';
import 'package:sparkduet/features/countries/data/store/countries_cubit.dart';
import 'package:sparkduet/features/countries/data/store/countries_state.dart';
import 'package:sparkduet/features/countries/data/store/enums.dart';
import 'package:sparkduet/features/countries/presentation/widgets/selected_country_item_widget.dart';
import 'package:sparkduet/features/search/presentation/widgets/search_field_widget.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_checkbox_widget.dart';
import 'package:sparkduet/utils/custom_emtpy_content_widget.dart';

class CountriesPage extends StatefulWidget {

  final List<CountryModel>? selectedCountries;
  final Function(List<CountryModel>)? onSelectionChanged;
  const CountriesPage({super.key, this.selectedCountries, this.onSelectionChanged});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {

  late CountriesCubit countriesCubit;
  late StreamSubscription countriesCubitStreamSubscription;
  late ValueNotifier<List<CountryModel>> filteredCountries;
  late ValueNotifier<List<CountryModel>> selectedCountries;

  @override
  void initState() {
    countriesCubit = context.read<CountriesCubit>();
    countriesCubitStreamSubscription = countriesCubit.stream.listen((event) {
      if(event.status == CountryStatus.fetchAllCountriesSuccessful) {
        filteredCountries.value = event.countries;
      }
    });
    countriesCubit.fetchAllCountries();
    filteredCountries = ValueNotifier(countriesCubit.state.countries);
    selectedCountries =  ValueNotifier(widget.selectedCountries ?? []);
    super.initState();
  }


  void onSearchTextChanged(String? value) {
    EasyDebounce.debounce('search-country', const Duration(milliseconds: 1000), () {
      if(value == '' || value == null){
        filteredCountries.value = countriesCubit.state.countries;
      }else {
        final filteredItems = countriesCubit.state.countries.where((element) => (element.countryName ?? '').toLowerCase().contains(value.trim().toLowerCase())).toList();
        filteredCountries.value = filteredItems;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: const Text("Select countries", style: TextStyle(fontSize: 16),),
            backgroundColor: theme.colorScheme.surface,
            centerTitle: false,
            leading: const CloseButton(),
            pinned: true,
            elevation: 1,
            bottom:  PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: SearchFieldWidget(onChanged: onSearchTextChanged,),
              ),
            ),
            actions: [
              TextButton(onPressed: () {
                context.popScreen();
              }, child: Text("Done", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),))
            ],
          ),

          SliverToBoxAdapter(
            child: ValueListenableBuilder<List<CountryModel>>(valueListenable: selectedCountries, builder: (_, list, ch) {
              if(list.isEmpty) {
                return const SizedBox.shrink();
              }
              return ch ??  const SizedBox.shrink();
            }, child: const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 20),
              child: Text("Selected"),
            ),),
          ),

          SliverToBoxAdapter(
            child:
            ValueListenableBuilder<List<CountryModel>>(valueListenable: selectedCountries, builder: (_, selectedList, __) {
              return Container(
                decoration: BoxDecoration(
                    color: theme.colorScheme.surface
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: [
                    ...List.generate(selectedList.length, (index) {
                      final country = selectedList[index];
                      return  SelectedCountryItemWidget(country: CountryModel(countryName: country.countryName, countryCode: country.countryCode,), onTap: (){
                        if(selectedList.contains(country)){
                          selectedCountries.value = <CountryModel>[...selectedList..remove(country)];
                          widget.onSelectionChanged?.call(selectedCountries.value);
                        }
                      },);
                    })
                  ],
                ),
              );
            }),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 20),
              child: Text("Countries"),
            ),
          )


        ];
      }, body:
      BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, countriesState) {
          if(countriesState.status == CountryStatus.fetchAllCountriesInProgress){
            return const Center(
              child: CustomAdaptiveCircularIndicator(),
            );
          }
          return ValueListenableBuilder<List<CountryModel>>(valueListenable: filteredCountries, builder: (_, filteredList, __) {

            if(filteredList.isEmpty){
              return Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: theme.colorScheme.surface
                      ),
                      child: const CustomEmptyContentWidget()),
                ],
              );
            }

            return ListView.separated(itemBuilder: (ctx, i) {
              final country = filteredList[i];
              return ValueListenableBuilder(valueListenable: selectedCountries, builder: (_, selectedList, __) {
                final checked = selectedList.contains(country);
                return GestureDetector(
                  onTap: () {
                    if(selectedList.contains(country)){
                      selectedCountries.value = <CountryModel>[...selectedList..remove(country)];
                    }else {
                      selectedCountries.value = <CountryModel>[...selectedList..add(country)];
                    }

                    widget.onSelectionChanged?.call(selectedCountries.value);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: theme.colorScheme.surface
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: theme.colorScheme.outlineVariant,
                                borderRadius: BorderRadius.circular(50)
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(FeatherIcons.search, size: 18,),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(child: Text(country.countryName ?? '', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, fontSize: 14),),),
                          const SizedBox(width: 10,),
                          IgnorePointer(
                            ignoring: true,
                            child: CustomCheckboxWidget(onChange: (value) {
                              // above18.value = true;
                            }, borderRadius: 3, size: 25,
                              borderColor: theme.colorScheme.outline.withOpacity(0.5),
                              // fillColor: theme.brightness == Brightness.dark ? theme.colorScheme.outlineVariant : theme.colorScheme.background,
                              checked: checked,),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            }, itemCount: filteredList.length, separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 1,);
            }, padding: const EdgeInsets.only(top: 0),);
          });
        },
      ),

      ),
    );
  }
}
