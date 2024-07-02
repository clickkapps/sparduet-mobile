import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/home/data/store/nav_cubit.dart';
import 'package:sparkduet/features/preferences/presentation/pages/display_settings_page.dart';
import 'package:sparkduet/features/preferences/presentation/pages/feedback_page.dart';
import 'package:sparkduet/features/preferences/presentation/pages/notifications_settings_page.dart';
import 'package:sparkduet/features/auth/presentation/mixin/auth_mixin.dart';
import 'package:sparkduet/features/preferences/presentation/widgets/delete_account_widget.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_state.dart';
import 'package:sparkduet/features/subscriptions/presentation/ui_mixin/subsription_page_mixin.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/mixin/launch_external_app_mixin.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'dart:io' show Platform;

class PreferencesPage extends StatelessWidget with LaunchExternalAppMixin, AuthMixin, SubscriptionPageMixin {

  const PreferencesPage({super.key});


  void  showCreateFeedbackHandler(BuildContext context) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.7,
          builder: (_ , controller) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: FeedbackPage(controller: controller)
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) {
      // context.read<ThemeCubit>().setSystemUIOverlaysToDark();
    });
  }

  void  showDisplaySettingsHandler(BuildContext context) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.7,
          builder: (_ , controller) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: DisplaySettingsPage(controller: controller)
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) {
      // context.read<ThemeCubit>().setSystemUIOverlaysToDark();
    });
  }

  void  showNotificationSettingsHandler(BuildContext context) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.7,
          builder: (_ , controller) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: NotificationsSettingsPage(controller: controller)
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) {
      // context.read<ThemeCubit>().setSystemUIOverlaysToDark();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
          title: const Text(""),
        leading: CloseButton(color: theme.colorScheme.onBackground, onPressed: () => {
          context.read<NavCubit>().requestTabChange(NavPosition.home)
        },),
        actions: [
          if(theme.brightness == Brightness.dark) ... {
            IconButton(onPressed: () {
              context.read<ThemeCubit>().setLightMode();
              context.read<ThemeCubit>().setSystemUIOverlaysToLight();
            }, icon: const Icon(FeatherIcons.moon))
          }else ... {
            IconButton(onPressed: () {
              context.read<ThemeCubit>().setDarkMode();
              context.read<ThemeCubit>().setSystemUIOverlaysToDark();
            }, icon: const Icon(FeatherIcons.sun)),
          },
          const SizedBox(width: 10,)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SeparatedColumn(
           separatorBuilder: (BuildContext context, int index) {
             return const SizedBox(height: 15,);
           },
           children: [

              Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15),
               child: CustomCard(padding: 5,child: SeparatedColumn(
                 separatorBuilder: (BuildContext context, int index) {
                   return const CustomBorderWidget();
                 },
                 children: [
                   ListTile(
                     dense: true,
                     title: Text("Dating Blog", style: theme.textTheme.bodyMedium,),
                     trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                     onTap: () {
                       launchBrowser(AppConstants.blog);
                     },
                   ),
                 ],
               ),),
             ),

             /// Dating Blog
              Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15),
               child: CustomCard(padding: 5,child: SeparatedColumn(
                 separatorBuilder: (BuildContext context, int index) {
                   return const CustomBorderWidget();
                 },
                 children: [
                   ListTile(
                     dense: true,
                     title: Text("Notification Settings", style: theme.textTheme.bodyMedium,),
                     trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                     onTap: () {
                       showNotificationSettingsHandler(context);
                     },
                   ),
                   ListTile(
                       dense: true,
                       title: Text("Display Settings", style: theme.textTheme.bodyMedium,),
                       trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         showDisplaySettingsHandler(context);
                       },
                   ),
                 ],
               ),),
             ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomCard(padding: 5,child: SeparatedColumn(
                   separatorBuilder: (BuildContext context, int index) {
                     return const CustomBorderWidget();
                   },
                   children: [

                     ListTile(
                       dense: true,
                       title: Text("Feedback", style: theme.textTheme.bodyMedium,),
                       trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         showCreateFeedbackHandler(context);
                       },
                     ),

                     ListTile(
                       dense: true,
                       title: Text("Live support", style: theme.textTheme.bodyMedium,),
                       trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         launchBrowser(AppConstants.website);
                       },
                     ),
                     ListTile(
                         dense: true,
                       title: Text("FAQ", style: theme.textTheme.bodyMedium,),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         launchBrowser(AppConstants.faq);
                       },
                     ),
                     ListTile(
                       dense: true,
                       title: Text("Privacy Policy", style: theme.textTheme.bodyMedium,),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         launchBrowser(AppConstants.privacyPolicy);
                       }
                     ),
                     ListTile(
                       dense: true,
                       title: Text("Terms Of Use", style: theme.textTheme.bodyMedium,),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         launchBrowser(AppConstants.termsOfUse);
                       },
                     ),

                     BlocBuilder<SubscriptionCubit, SubscriptionState>(
                       builder: (context, state) {
                         return ListTile(
                           dense: true,
                           title: Text("Subscription", style: theme.textTheme.bodyMedium,),
                           trailing: Text(state.subscribed ? "Paid" : "Free", style: theme.textTheme.bodyMedium?.copyWith(color: state.subscribed ? null : AppColors.buttonBlue),),
                           onTap: () {
                             if(state.subscribed) {
                               // const url = 'http://play.google.com/store/account/subscriptions';
                               // launchBrowser(url);
                               final store = Platform.isAndroid ? "Play Store" : "App Store";
                               context.showSnackBar("You are currently on the paid subscription. To unsubscribe, kindly visit your $store. Thanks");
                               return;
                             }

                             showSubscriptionPaywall(context, openAsModal: true);

                           },
                         );
                       },
                     ),
                     ListTile(
                       dense: true,
                       title: Text("Logout", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         context.showConfirmDialog(title: "Do you want to logout?",
                           subtitle: "You'd have to login again next time you open the app",
                           onConfirmTapped: () {
                            logout(context);
                           },
                         );

                       },
                     )
                   ],
                ),),
              ),

             const DeleteAccount(),
           ],
        ),
      ),
    );
  }
}
