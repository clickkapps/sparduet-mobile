import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/countries/data/models/country_model.dart';
import 'package:sparkduet/features/countries/data/store/countries_cubit.dart';
import 'package:sparkduet/features/countries/data/store/countries_state.dart';
import 'package:sparkduet/features/countries/presentation/pages/countries_page.dart';
import 'package:sparkduet/features/countries/presentation/widgets/selected_country_item_widget.dart';
import 'package:sparkduet/features/users/data/models/user_info_model.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';

class FilterFeedsWidget extends StatefulWidget {

  final ScrollController? scrollController;
  const FilterFeedsWidget({super.key, this.scrollController});

  @override
  State<FilterFeedsWidget> createState() => _FilterFeedsWidgetState();
}

class _FilterFeedsWidgetState extends State<FilterFeedsWidget> {

  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();
  late AuthCubit authCubit;

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    final authUser = authCubit.state.authUser;
    if(authUser?.info?.preferredMinAge != null) {
      minAgeController.text =  "${authUser?.info?.preferredMinAge}";
    }
    if(authUser?.info?.preferredMaxAge != null) {
      maxAgeController.text =  "${authUser?.info?.preferredMaxAge}";
    }

    super.initState();
  }

  void setPreferredGendersHandler(List<String> existingSelectedGenders, String gender) {

    if(existingSelectedGenders.contains(gender)){
      existingSelectedGenders.remove(gender);
    }else{
      existingSelectedGenders.add(gender);
    }

    // any should be selected or a combination of the others
    if(existingSelectedGenders.length > 1 && existingSelectedGenders.contains("any")) {
      existingSelectedGenders.remove("any");
    }
    if(existingSelectedGenders.isEmpty){
      existingSelectedGenders.add("any");
    }

    if(gender == "any"){
      existingSelectedGenders.clear();
      existingSelectedGenders.add("any");
    }

    final encoded = json.encode(existingSelectedGenders);
    authCubit.updateAuthUserProfile(payload: {"preferred_gender": encoded},
      authUser: authCubit.state.authUser?.copyWith(info: authCubit.state.authUser?.info?.copyWith(preferredGender: encoded)) //this will cause immediate update
    );

  }

  void setPreferredRaceHandler(List<String> existingSelectedRace, String race) {

    if(existingSelectedRace.contains(race)){
      existingSelectedRace.remove(race);
    }else{
      existingSelectedRace.add(race);
    }

    // any should be selected or a combination of the others
    if(existingSelectedRace.length > 1 && existingSelectedRace.contains("any")) {
      existingSelectedRace.remove("any");
    }
    if(existingSelectedRace.isEmpty){
      existingSelectedRace.add("any");
    }

    if(race == "any"){
      existingSelectedRace.clear();
      existingSelectedRace.add("any");
    }

    final encoded = json.encode(existingSelectedRace);
    authCubit.updateAuthUserProfile(payload: {"preferred_races": encoded},
        authUser: authCubit.state.authUser?.copyWith(info: authCubit.state.authUser?.info?.copyWith(preferredRaces: encoded)) //this will cause immediate update
    );

  }

  void setPreferredMinAge(String? age) {
    EasyDebounce.debounce('update-min-age', const Duration(milliseconds: 1000), () {
      if(age == null) {return;}
      if(int.tryParse(age) == null){return;}
      final ageAsNumber = int.parse(age);
      final minAge = ageAsNumber < 18 ? 18 : ageAsNumber;
      authCubit.updateAuthUserProfile(payload: {"preferred_min_age": minAge},
          authUser: authCubit.state.authUser?.copyWith(info: authCubit.state.authUser?.info?.copyWith(preferredMinAge: minAge)));
    });
  }
  void setPreferredMaxAge(String? age) {
    EasyDebounce.debounce('update-max-age', const Duration(milliseconds: 1000), () {
      if(age == null) {return;}
      if(int.tryParse(age) == null){return;}
      final maxAge = int.parse(age);
      authCubit.updateAuthUserProfile(payload: {"preferred_max_age": maxAge},
      authUser: authCubit.state.authUser?.copyWith(info: authCubit.state.authUser?.info?.copyWith(preferredMaxAge: maxAge)));
    });
  }

  void setPreferredNationalities(String key, List<String> values) {
    final encoded = json.encode({
      'key': key,
      'values': values
    });
    authCubit.updateAuthUserProfile(payload: {"preferred_nationalities": encoded},
        authUser: authCubit.state.authUser?.copyWith(info: authCubit.state.authUser?.info?.copyWith(preferredNationalities: encoded)));
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

              return [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: Text("Filter posts", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),),
                  actions: [
                    TextButton(onPressed: () {
                      context.popScreen();
                    }, child: Text("Done", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),)),
                  ],
                )
              ];

          }, body: SingleChildScrollView(
            controller: widget.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (_, state) {
                return state.status == AuthStatus.setAuthUserInfoCompleted;
              },
              builder: (context, authState) {
                final authUser = authState.authUser;
                List<String> preferredGenders = [];
                List<String> preferredRaces = [];
                Map<String, dynamic> preferredNationalities = {}; // { key: "All", values: [ "GH", "US", "CA", ... ]}
                if((authUser?.info?.preferredGender ?? "").isNotEmpty) {
                  final items = json.decode(authUser?.info?.preferredGender ?? "") as List<dynamic>;
                  preferredGenders.addAll(items.map((e) => e as String));
                }

                if((authUser?.info?.preferredRaces ?? "").isNotEmpty) {
                  final items = json.decode(authUser?.info?.preferredRaces ?? "") as List<dynamic>;
                  preferredRaces.addAll(items.map((e) => e as String));
                }

                if((authUser?.info?.preferredNationalities ?? "").isNotEmpty) {
                  final map = json.decode(authUser?.info?.preferredNationalities ?? "") as Map<String, dynamic>;
                  final key = map["key"] as String;
                  final values = map["values"] as List<dynamic>;
                  final countries = values.map<String>((e) => e as String).toList();
                  preferredNationalities["key"] = key;
                  preferredNationalities["values"] = countries;
                }

                return SeparatedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10,);
                  },
                  children: [
                    ///! Gender
                    CustomCard(
                      child:  Builder(builder: (_) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10,),
                              child: Text("Your preferred genders",
                                style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700),),
                            ),
                            const SizedBox(height: 0,),
                            Container(
                              padding: const EdgeInsets.all(0),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                // border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: SeparatedColumn(
                                separatorBuilder: (BuildContext context, int index) {
                                  return const CustomBorderWidget();
                                },
                                children: [

                                  ...AppConstants.preferredGenderList.map((item) {
                                    return GestureDetector(
                                      onTap: () {
                                          setPreferredGendersHandler(preferredGenders, item["key"] as String);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item["name"] as String),
                                              if(preferredGenders.contains(item["key"])) ... {
                                                const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                              }


                                          ],
                                        ),
                                      ),
                                    );
                                  })


                                ],
                              ),
                            )

                          ],
                        );
                      }),
                    ),

                    ///! Ages
                    CustomCard(
                      child: Builder(builder: (_) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10,),
                              child: Text("Your preferred ages",
                                style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700),),
                            ),
                            Row(
                              children: [
                                Expanded(child: CustomTextFieldWidget(
                                  controller: minAgeController,
                                  label: "Min age",
                                  placeHolder: "eg. 18",
                                  inputType: TextInputType.number,
                                  onChange: setPreferredMinAge,
                                )),
                                const SizedBox(width: 10,),
                                Expanded(child: CustomTextFieldWidget(
                                  controller: maxAgeController,
                                  label: "Max age",
                                  placeHolder: "eg. 70",
                                  inputType: TextInputType.number,
                                  onChange: setPreferredMaxAge,
                                )),
                              ],
                            )
                          ],
                        );
                      }),
                    ),

                    ///! Races
                    CustomCard(
                      child: Builder(builder: (_) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10,),
                              child: Text("Your preferred race",
                                style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700),),
                            ),
                            Container(
                              padding: const EdgeInsets.all(0),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                // border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: SeparatedColumn(
                                separatorBuilder: (BuildContext context, int index) {
                                  return const CustomBorderWidget();
                                },
                                children: [

                                  ...AppConstants.preferredRaces.map((item) {
                                    return  GestureDetector(
                                      onTap: () {
                                        setPreferredRaceHandler(preferredRaces, item['key'] as String);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item["name"] as String),
                                            if(preferredRaces.contains(item["key"])) ... {
                                              const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                            }
                                          ],
                                        ),
                                      ),
                                    );
                                  })

                                ],
                              ),
                            )

                          ],
                        );
                      }),
                    ),

                    ///! Nationalities
                    if(preferredNationalities.isNotEmpty) ... {
                      BlocSelector<CountriesCubit, CountriesState, List<CountryModel>>(
                        selector: (state) {
                          return state.countries;
                        },
                        builder: (context, countries) {
                          if(countries.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return CustomCard(
                            child: Builder(builder: (_) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10,),
                                    child: Text("Your preferred nationalities",
                                      style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700),),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(0),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: SeparatedColumn(
                                      separatorBuilder: (BuildContext context, int index) {
                                        return const CustomBorderWidget();
                                      },
                                      children: [

                                        GestureDetector(
                                          onTap: () {
                                            setPreferredNationalities("all", <String>[]);
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("All"),
                                                if(preferredNationalities["key"] == "all") ... {
                                                  const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                }

                                              ],
                                            ),
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: () {
                                            List<CountryModel> selectedCountries = [];
                                            if(preferredNationalities["key"] == "only") {
                                              final list = preferredNationalities['values'] as List<dynamic>;
                                              selectedCountries = countries.where((element) => list.contains(element.countryCode)).toList();
                                            }
                                            context.pushScreen(CountriesPage(selectedCountries: selectedCountries, onSelectionChanged: (selectedCountries) {
                                              setPreferredNationalities("only", selectedCountries.map((e) => e.countryCode ?? "").toList());
                                            },));
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: SeparatedColumn(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              separatorBuilder: (BuildContext context, int index) {
                                                return const SizedBox(height: 10,);
                                              },
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text("Only"),
                                                    if(preferredNationalities["key"] == "only") ... {
                                                      const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                    }
                                                  ],
                                                ),
                                                if(preferredNationalities['values'] is List<dynamic> && preferredNationalities["key"] == "only") ... {
                                                  Builder(builder: (_) {
                                                    final list = preferredNationalities['values'] as List<dynamic>;

                                                    return Wrap(
                                                      runSpacing: 8,
                                                      spacing: 8,
                                                      children: [
                                                        ...list.map((element) {
                                                          final countryCode = element as String;
                                                          final country = countries.where((element) => element.countryCode == countryCode).firstOrNull;
                                                          if(country == null) {
                                                            return const SizedBox.shrink();
                                                          }
                                                          return IgnorePointer(
                                                              ignoring: true,
                                                              child: SelectedCountryItemWidget(country: country)
                                                          );
                                                        })
                                                      ],
                                                    );
                                                  })
                                                }
                                              ],
                                            ),
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: () {

                                            List<CountryModel> selectedCountries = [];
                                            if(preferredNationalities["key"] == "except") {
                                              final list = preferredNationalities['values'] as List<dynamic>;
                                              selectedCountries = countries.where((element) => list.contains(element.countryCode)).toList();
                                            }
                                            context.pushScreen(CountriesPage(selectedCountries: selectedCountries, onSelectionChanged: (selectedCountries) {
                                              setPreferredNationalities("except", selectedCountries.map((e) => e.countryCode ?? "").toList());
                                            },));
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: SeparatedColumn(
                                              separatorBuilder: (BuildContext context, int index) {
                                                return const SizedBox(height: 10,);
                                              },
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text("Except"),
                                                    if(preferredNationalities["key"] == "except") ... {
                                                      const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                    }
                                                  ],
                                                ),
                                                if(preferredNationalities['values'] is List<dynamic> && preferredNationalities["key"] == "except") ... {
                                                  Builder(builder: (_) {
                                                    final list = preferredNationalities['values'] as List<dynamic>;

                                                    return Wrap(
                                                      runSpacing: 8,
                                                      spacing: 8,
                                                      children: [
                                                        ...list.map((element) {
                                                          final countryCode = element as String;
                                                          final country = countries.where((element) => element.countryCode == countryCode).firstOrNull;
                                                          if(country == null) {
                                                            return const SizedBox.shrink();
                                                          }
                                                          return IgnorePointer(
                                                              ignoring: true,
                                                              child: SelectedCountryItemWidget(country: country)
                                                          );
                                                        })
                                                      ],
                                                    );
                                                  })
                                                }
                                              ],
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
                          );

                        },
                      ),
                    },


                  ],
                );
              },
            ),
          ),
          ),
        )
    );

  }
}
