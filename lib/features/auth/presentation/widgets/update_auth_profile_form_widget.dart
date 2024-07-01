import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/models/auth_user_model.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/auth/presentation/mixin/auth_profile_mixin.dart';
import 'package:sparkduet/features/users/data/models/user_info_model.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';

class UpdateAuthProfileFormWidget extends StatefulWidget {

  final ScrollController? scrollController;
  final Function()? onComplete;
  final bool showName;
  final bool showBio;
  final bool showAge;
  final bool showGender;
  final bool showRace;
  final String? title;
  const UpdateAuthProfileFormWidget({
    super.key, this.scrollController,
    this.showName = false,
    this.showBio = false,
    this.showAge = false,
    this.showGender = false,
    this.showRace = false,
    this.title,
    this.onComplete
  });

  @override
  State<UpdateAuthProfileFormWidget> createState() => _UpdateAuthProfileFormWidgetState();
}

class _UpdateAuthProfileFormWidgetState extends State<UpdateAuthProfileFormWidget> with AuthUIMixin {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController raceController = TextEditingController();
  late AuthCubit authCubit;

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    final authUser = authCubit.state.authUser;
    if((authUser?.name ?? "").isNotEmpty) {
      nameController.text = authUser?.name ?? "";
    }
    if((authUser?.info?.bio ?? "").isNotEmpty) {
      bioController.text = authUser?.info?.bio ?? "";
    }
    if(authUser?.info?.age != null) {
      ageController.text = "${authUser?.info?.age}";
    }
    if((authUser?.info?.gender ?? "").isNotEmpty) {
      final text = AppConstants.genderList.where((element) => element["key"] == (authUser?.info?.gender ?? "")).firstOrNull?["name"];
      genderController.text = text ?? "";
    }

    if((authUser?.info?.race ?? "").isNotEmpty) {
      final text = AppConstants.races.where((element) => element["key"] == (authUser?.info?.race ?? "")).firstOrNull?["name"];
      raceController.text = text ?? "";
    }
    super.initState();
  }


  //! Submit form fields
  void updateName(String field) {
    EasyDebounce.debounce('update-name', const Duration(milliseconds: 1000), () {
      authCubit.updateAuthUserProfile(payload: {"name": field}, authUser: authCubit.state.authUser?.copyWith(name: field));
    });
  }
  void updateBio(String field) {
    EasyDebounce.debounce('update-bio', const Duration(milliseconds: 1000), () {
      if(containsPhoneNumber(field)) {
        return;
      }
      authCubit.updateAuthUserProfile(payload: {"bio": field}, authUser: authCubit.state.authUser?.copyWith(info: authCubit.state.authUser?.info?.copyWith(bio: field)));
    });
  }
  void updateAge(String field) {
    EasyDebounce.debounce('update-age', const Duration(milliseconds: 1000), () {
      if(int.tryParse(field) != null) {
        authCubit.updateAuthUserProfile(payload: {"age": field}, authUser: authCubit.state.authUser?.copyWith(
            info: authCubit.state.authUser?.info?.copyWith(age: num.parse(field)),
            displayAge: num.parse(field)
        ));
      }

    });
  }
  // gender will be set by gender_list_widget

  // End of submit form fields

  void authStateListener(_, AuthState event) {
    if(event.status == AuthStatus.setAuthUserInfoCompleted) {
      if((event.authUser?.info?.gender ?? "").isNotEmpty) {
        final text = AppConstants.genderList.where((element) => element["key"] == (event.authUser?.info?.gender ?? "")).firstOrNull?["name"];
        genderController.text = text ?? "";
      }

      if((event.authUser?.info?.race ?? "").isNotEmpty) {
        final text = AppConstants.races.where((element) => element["key"] == (event.authUser?.info?.race ?? "")).firstOrNull?["name"];
        raceController.text = text ?? "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Update personal data", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [
          CloseButton()
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: authStateListener,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: SeparatedColumn(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10,);
            },
            children: [
              if(widget.showName) ... {
                CustomTextFieldWidget(
                  label: "Your name",
                  controller: nameController,
                  onChange: (val) => val != null ? updateName(val) : null,
                )
              },

              if(widget.showBio) ... {
                CustomTextFieldWidget(
                  label: "Your Bio",
                  controller: bioController,
                  minLines: 5,
                  maxLines: null,
                  onChange: (val) => val != null ? updateBio(val) : null,
                )
              },
              if(widget.showAge) ... {
                CustomTextFieldWidget(
                  label: "Your Age",
                  controller: ageController,
                  inputType: TextInputType.number,
                  onChange: (val) => val != null ? updateAge(val) : null,
                )
              },
              if(widget.showGender) ... {
                CustomTextFieldWidget(
                  label: "Your Gender",
                  readOnly: true,
                  onTap: () => showGenderSelectorListWidget(context),
                  controller: genderController,
                )
              },
              if(widget.showRace) ... {
                CustomTextFieldWidget(
                  label: "Your Race",
                  readOnly: true,
                  onTap: () => showRaceSelectorListWidget(context),
                  controller: raceController,
                )
              },

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomButtonWidget(text: "Done", onPressed: () {
                  widget.onComplete?.call();
                }, appearance: ButtonAppearance.primary, expand: true,),
              )

            ],
          ),
        ),
      )
    );
  }
}
