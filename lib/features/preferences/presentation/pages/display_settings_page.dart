import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/features/theme/data/store/enums.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/features/theme/data/store/theme_state.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';

class DisplaySettingsPage extends StatefulWidget {

  final ScrollController? controller;
  const DisplaySettingsPage({super.key, this.controller});

  @override
  State<DisplaySettingsPage> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  
  late ThemeCubit themeCubit;
  
  @override
  void initState() {
    themeCubit = context.read<ThemeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          // automaticallyImplyLeading: false,
          leading: const CloseButton(),
          title: Text("Display Settings", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        body: SingleChildScrollView(
          controller: widget.controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return SeparatedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10,);
                          },
                          children: [
                            CustomCard(
                              child: Builder(builder: (_) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10,),
                                      child: Text("Theme brightness",
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
                                              context.read<ThemeCubit>().setDarkMode();
                                              context.read<ThemeCubit>().setSystemUIOverlaysToDark();
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text("Dark mode"),
                                                  if(themeState.themeData?.brightness == Brightness.dark) ... {
                                                    const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                  }

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              context.read<ThemeCubit>().setLightMode();
                                              context.read<ThemeCubit>().setSystemUIOverlaysToLight();
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text("Light mode"),
                                                  if(themeState.themeData?.brightness == Brightness.light) ... {
                                                    const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                  }
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                            ),

                            CustomCard(
                              child: Builder(builder: (_) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10,),
                                      child: Text("Font style",
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
                                              themeCubit.setFont(AppFont.quicksand);
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Default", style: GoogleFonts.lato(),),
                                                  if(themeState.appFont == AppFont.quicksand) ... {
                                                    const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                  }

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              themeCubit.setFont(AppFont.spaceMono);
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Space Mono", style: GoogleFonts.spaceMono(),),
                                                  if(themeState.appFont == AppFont.spaceMono) ... {
                                                    const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                  }
                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              themeCubit.setFont(AppFont.robotoSlab);
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Dancing Script", style: GoogleFonts.dancingScript(),),
                                                  if(themeState.appFont == AppFont.robotoSlab) ... {
                                                    const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                  }
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                            ),
                          ],
                        );
              },
            ),
          ),
        )
    );
  }
}
