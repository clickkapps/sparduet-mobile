import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/home/data/nav_cubit.dart';
import 'package:sparkduet/features/preferences/presentation/widgets/delete_account_widget.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/mixin/launch_external_app_mixin.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';

class PreferencesPage extends StatelessWidget with LaunchExternalAppMixin {

  const PreferencesPage({super.key});
  
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
                       launchBrowser(AppConstants.blog, context);
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
                   ),
                   ListTile(
                       dense: true,
                       title: Text("Display Settings", style: theme.textTheme.bodyMedium,),
                       trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,)
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
                       title: Text("Suggestions Box", style: theme.textTheme.bodyMedium,),
                       trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                     ),

                     ListTile(
                       dense: true,
                       title: Text("Contact Support", style: theme.textTheme.bodyMedium,),
                       trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                     ),
                     ListTile(
                         dense: true,
                       title: Text("FAQ", style: theme.textTheme.bodyMedium,),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         launchBrowser(AppConstants.faq, context);
                       },
                     ),
                     ListTile(
                       dense: true,
                       title: Text("Privacy Policy", style: theme.textTheme.bodyMedium,),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         launchBrowser(AppConstants.privacyPolicy, context);
                       }
                     ),
                     ListTile(
                       dense: true,
                       title: Text("Terms Of Use", style: theme.textTheme.bodyMedium,),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         launchBrowser(AppConstants.termsOfUse, context);
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
                             context.read<AuthCubit>().logout();
                             context.go(AppRoutes.login);
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
