import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/users/data/models/user_model.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/features/users/data/store/user_state.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class YouBlockedUserExplanationPage extends StatelessWidget {

  final ScrollController? controller;
  final Function()? onCloseTapped;
  final UserModel user;
  const YouBlockedUserExplanationPage({super.key, this.controller, this.onCloseTapped, required this.user});

  void userCubitListener(BuildContext context, UserState event) {
    if(event.status == UserStatus.setUserBlockedStatusCompleted) {
      if(context.mounted) {
        if(!event.youBlockedUser) {
          context.popScreen();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: userCubitListener,
        child: SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Lottie.asset(AppAssets.kBlockedIconJson, height:  media.size.width * 0.4),
              const SizedBox(height: 15,),
              Text("Blocked", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),),
              const SizedBox(height: 10,),
              Text('You blocked this user. This user will no longer see your posts', style: theme.textTheme.bodyMedium?.copyWith(height: 1.5), textAlign: TextAlign.center,),
              const SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(child: CustomButtonWidget(text: "Go back", onPressed: () {
                    context.popScreen();
                    onCloseTapped?.call();
                  }, expand: true,)),
                  const SizedBox(width: 10,),
                  Expanded(child: CustomButtonWidget(text: "Unblock", onPressed: () {
                    context.read<UserCubit>().unBlockUser(offenderId: user.id);
                  }, expand: true, appearance: ButtonAppearance.secondary,))
                ],
              )
            ],
          ),
      ),
    ));
  }
}
