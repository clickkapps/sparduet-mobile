import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/features/preferences/data/store/enums.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_cubit.dart';
import 'package:sparkduet/features/preferences/data/store/preferences_state.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';

class NotificationsSettingsPage extends StatefulWidget {

  final ScrollController? controller;
  const NotificationsSettingsPage({super.key, this.controller});

  @override
  State<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {

  late PreferencesCubit preferencesCubit;

  @override
  void initState() {
    preferencesCubit = context.read<PreferencesCubit>();
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
          title: Text("Notification Settings", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        body: SingleChildScrollView(
          controller: widget.controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SeparatedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10,);
              },
              children: [
                CustomCard(
                  child: BlocBuilder<PreferencesCubit, PreferencesState>(
                      buildWhen: (_, state) {
                        return state.status == PreferencesStatus.saveSettingsCompleted;
                      },
                      builder: (_, prefState) {
                      return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            // border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: SeparatedColumn(
                            separatorBuilder: (BuildContext context, int index) {
                              return const CustomBorderWidget(paddingBottom: 5, paddingTop: 5,);
                            },
                            children: [

                              GestureDetector(
                                onTap: () {
                                  final value = !preferencesCubit.state.enableChatNotifications;
                                  preferencesCubit.updateUserSettings(payload: {"enable_chat_notifications": value ? 1 : 0 });
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(child: Text("Enable chat notifications")),
                                      const SizedBox(width: 10,),
                                      SizedBox(
                                        width: 40,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: CupertinoSwitch(
                                            value: prefState.enableChatNotifications,
                                            onChanged: (bool value) { preferencesCubit.updateUserSettings(payload: {"enable_chat_notifications": value ? 1 : 0}); },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  final value = !preferencesCubit.state.enableProfileViewsNotifications;
                                  preferencesCubit.updateUserSettings(payload: {"enable_profile_views_notifications": value ? 1 : 0});
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(child: Text("Enable profile view notifications")),
                                      const SizedBox(width: 10,),
                                      SizedBox(
                                        width: 40,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: CupertinoSwitch(
                                            value: prefState.enableProfileViewsNotifications,
                                            onChanged: (bool value) { preferencesCubit.updateUserSettings(payload: {"enable_profile_views_notifications": value ? 1 : 0}); },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              // GestureDetector(
                              //   onTap: () {
                              //     final value = !preferencesCubit.state.enableStoryViewsNotifications;
                              //     preferencesCubit.updateUserSettings(payload: {"enable_story_views_notifications": value ? 1 : 0 });
                              //   },
                              //   behavior: HitTestBehavior.opaque,
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(vertical: 10),
                              //     child:  Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         const Expanded(child: Text("Enable viewed stories notifications")),
                              //         const SizedBox(width: 10,),
                              //         SizedBox(
                              //           width: 40,
                              //           child: FittedBox(
                              //             fit: BoxFit.contain,
                              //             child: CupertinoSwitch(
                              //               value: prefState.enableStoryViewsNotifications,
                              //               onChanged: (bool value) { preferencesCubit.updateUserSettings(payload: {"enable_story_views_notifications": value ? 1 : 0}); },
                              //             ),
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),

                            ],
                          ),
                        )
                      ],
                    );
                  }),
                ),


              ],
            ),
          ),
        )
    );
  }
}
