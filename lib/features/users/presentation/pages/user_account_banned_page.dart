import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/preferences/presentation/ui_mixins/preferences_mixin.dart';
import 'package:sparkduet/features/users/data/models/user_disciplinary_record_model.dart';
import 'package:sparkduet/features/users/data/store/enums.dart';
import 'package:sparkduet/features/users/data/store/user_cubit.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

class UserAccountBannedPage extends StatefulWidget {

  final ScrollController? controller;
  final UserDisciplinaryRecordModel disRecord;
  const UserAccountBannedPage({super.key, this.controller, required this.disRecord});

  @override
  State<UserAccountBannedPage> createState() => _UserAccountBannedPageState();
}

class _UserAccountBannedPageState extends State<UserAccountBannedPage> with PreferencesMixin {

  late UserCubit userCubit;
  @override
  void initState() {
    userCubit = context.read<UserCubit>();
    userCubit.stream.listen((event) {
      if(event.status == UserStatus.getDisciplinaryRecordSuccessful) {
        if(event.disciplinaryRecord == null && mounted) {
          context.popScreen(); // remove from screen if waning is take off
        }
      }
    });
    context.read<UserCubit>().markDisciplinaryRecordAsRead(id: widget.disRecord.id);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: widget.controller,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(AppAssets.kBlockedIconJson , height: MediaQuery.of(context).size.width  * 0.4),
              const SizedBox(height: 15,),
              Text("Account Banned", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),),
              const SizedBox(height: 10,),
              Text(widget.disRecord.reason ?? "", style: theme.textTheme.bodyMedium?.copyWith(height: 1.5), textAlign: TextAlign.center,),
              const SizedBox(height: 15,),
              CustomButtonWidget(text: "Logout", onPressed: () {
                logout(context);
              }, expand: true,)
            ],
          ),
        ),
      ),
    );
  }
}
