import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_classes.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/presentation/widgets/update_auth_profile_form_widget.dart';
import 'package:sparkduet/features/users/data/models/user_info_model.dart';

mixin AuthUIMixin {
    void showAuthProfileUpdateModal(BuildContext context, {bool showName = false, bool showBio = false, bool showAge = false, bool showGender = false}) {
      final ch = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 1.0,
            minChildSize: 0.9,
            builder: (_ , controller) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: UpdateAuthProfileFormWidget(showName: showName, showBio: showBio, showAge: showAge, showGender: showGender,
                  scrollController: controller,
                  onComplete: () => context.popScreen(),),
              );
            }
        ),
      );

      context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
    }


    void showGenderSelectorListWidget(BuildContext context) {

      context.showCustomListBottomSheet(items: [
        ...AppConstants.genderList.map((gender) => ListItem(id: gender['key'] ?? "", title: gender['name'] ?? "",)),
      ], onItemTapped: (item) {
        final authCubit = context.read<AuthCubit>();
        authCubit.updateAuthUserProfile(payload: {"gender": item.id},
            authUser: authCubit.state.authUser?.copyWith(info: authCubit.state.authUser?.info?.copyWith(gender: item.id))// this will cause immediate update
        );
      });

    }

    void showRaceSelectorListWidget(BuildContext context) {

      context.showCustomListBottomSheet(items: [
        ...AppConstants.races.map((race) => ListItem(id: race['key'] ?? "", title: race['name'] ?? "",)),
      ], onItemTapped: (item) {
        final authCubit = context.read<AuthCubit>();
        authCubit.updateAuthUserProfile(payload: {"race": item.id},
            authUser: authCubit.state.authUser?.copyWith(info: authCubit.state.authUser?.info?.copyWith(race: item.id))// this will cause immediate update
        );
      });

    }


}