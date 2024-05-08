import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';

class PreferencesPage extends StatelessWidget {

  const PreferencesPage({super.key});



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
          title: const Text("Preferences"),
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
                       title: Text("Contact Support", style: theme.textTheme.bodyMedium,),
                       trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                     ),
                     ListTile(
                         dense: true,
                       title: Text("FAQ", style: theme.textTheme.bodyMedium,),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,)
                     ),
                     ListTile(
                       dense: true,
                       title: Text("Privacy Policy", style: theme.textTheme.bodyMedium,),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,)
                     ),
                     ListTile(
                       dense: true,
                       title: Text("Logout", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),),
                         trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
                       onTap: () {
                         context.read<AuthCubit>().logout();
                         context.go(AppRoutes.login);
                       },
                     )
                   ],
                ),),
              )
           ],
        ),
      ),
    );
  }
}
