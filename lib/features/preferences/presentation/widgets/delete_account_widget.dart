import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';


class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {

  final ValueNotifier<bool> activateDeleteAccountButton = ValueNotifier(false);
  late AuthCubit authCubit;

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    super.initState();
  }
  
  void authCubitStateListener(BuildContext ctx, AuthState event) {
    if(event.status == AuthStatus.deleteAccountCompleted) {
      // automatically logs user out
      ctx.go(AppApiRoutes.login);
    }
  }

  void openDeleteAccountModal(BuildContext context) {
    activateDeleteAccountButton.value = false;
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: theme.colorScheme.surface,
        context: context,
        builder: (ctx) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: CloseButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const CustomBorderWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Delete account',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Are you sure you want to delete your account? This will immediately log you out and you will not be able to log in again.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFieldWidget(
                      label: "To proceed, type “DELETE ACCOUNT” below",
                      placeHolder: "",
                      textCapitalization: TextCapitalization.characters,
                      onChange: (value) {
                        if (value!.trim().toUpperCase() == "DELETE ACCOUNT") {
                          activateDeleteAccountButton.value = true;
                        }else {
                          activateDeleteAccountButton.value = false;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: activateDeleteAccountButton,
                            builder: (ctx, bool activate, _) {
                              return BlocConsumer<AuthCubit, AuthState>(
                                listener: authCubitStateListener,
                                builder: (context, authState) {
                                  return CustomButtonWidget(
                                    text: "Delete account",
                                    loading: authState.status == AuthStatus.deleteAccountInProgress,
                                    appearance: activate
                                        ? ButtonAppearance.error
                                        : ButtonAppearance.clean,
                                    onPressed: activate ? () {
                                      // authCubit.deleteAccount();
                                      context.read<AuthCubit>().logout();
                                      context.go(AppRoutes.login);
                                    } : null);
                                },
                              );
                            },
                          );
                        }),
                      // const SizedBox(
                      //   height: kToolbarHeight,
                      // ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomCard(padding: 5,child: SeparatedColumn(
        separatorBuilder: (BuildContext context, int index) {
          return const CustomBorderWidget();
        },
        children: [
          ListTile(
            dense: true,
            title: Text("Delete Your Account", style: theme.textTheme.bodyMedium,),
            trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.onBackground, size: 18,),
            onTap: () {
              // launchBrowser(AppConstants.blog, context);
              openDeleteAccountModal(context);
            },
          ),
        ],
      ),),
    );
  }
}
