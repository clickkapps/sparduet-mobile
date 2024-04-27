import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/auth/presentation/widgets/terms_privacy_widget.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/mixin/form_mixin.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_page_loading_overlay.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';

class AuthorizeEmailPage extends StatefulWidget {

  final String email;
  final ScrollController? scrollController;
  final Function(String) onSuccess;
  const AuthorizeEmailPage({super.key, required this.email, this.scrollController, required this.onSuccess});

  @override
  State<AuthorizeEmailPage> createState() => _AuthorizeEmailPageState();
}

class _AuthorizeEmailPageState extends State<AuthorizeEmailPage> with FormMixin {

  String? code;
  final FocusNode codeFocusNode = FocusNode();
  late AuthCubit _authCubit;
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _themeCubit = context.read<ThemeCubit>();
    _themeCubit.setSystemUIOverlaysToLight(androidSystemNavigationBarColor: AppColors.lightColorScheme.surface, androidStatusBarIconBrightness: Brightness.light);
    super.initState();
  }

  // user enters the verification code received and submit
  void _onSubmitVerificationCodeTapped(BuildContext ctx) {

    codeFocusNode.unfocus();

    // email should not be null at this point
    if (!validateAndSaveOnSubmit(ctx)) {
      return;
    }

    _authCubit.authorizeEmail(email: widget.email, code: code!);
  }

  ///   resend verification code link
  void _onResendVerificationCodeTapped() {
    _authCubit.resendEmail(email: widget.email);
  }

  void authCubitListener(BuildContext ctx, AuthState authState) {
    if (authState.status == AuthStatus.submitEmailSuccessful) {
      context.showSnackBar('Email sent!');
    }

    if (authState.status == AuthStatus.authorizeEmailSuccessful) {
       widget.onSuccess(authState.data as String) ;// the data will be the token
       if(mounted) {
         context.popScreen();
       }
    }

    if(authState.status == AuthStatus.resendEmailFailed) {
      context.showSnackBar(authState.message);
    }

    if(authState.status == AuthStatus.resendEmailSuccessful) {
      context.showSnackBar('Email sent!');
    }
  }

  /// Build UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = AppColors.lightColorScheme;
    final style = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: colorScheme.onBackground
    );

    return BlocConsumer<AuthCubit, AuthState>(
      listener: authCubitListener,
      builder: (context, authState) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                centerTitle: true,
                elevation: 0,
                backgroundColor: colorScheme.surface,
                actions: [
                  CloseButton(color: colorScheme.onBackground,)
                ],
                title: Text("", style: TextStyle(color: colorScheme.onBackground),),
                iconTheme: IconThemeData(color: colorScheme.background),
                automaticallyImplyLeading: false,
                bottom:  PreferredSize(
                    preferredSize: const Size.fromHeight(2),
                    child: CustomBorderWidget(color: colorScheme.outlineVariant,)
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: kToolbarHeight,),
                      // const CustomDefaultLogoWidget(),
                      const SizedBox(height: 15,),
                      Column(
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Verify Your Email",
                              style: style,
                              children: const <TextSpan>[
                              ],
                            ),

                          ),

                        ],
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Form(
                          child: AnimationConfiguration.synchronized(
                              child: SlideAnimation(
                                  duration: const Duration(milliseconds: 800),
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Column(children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Please check your email (${widget
                                            .email}) for a code we sent. Didn’t receive it? Click resend email below",
                                        style:  TextStyle(
                                            color: colorScheme.onSurface,
                                            height: 1.5),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      CustomTextFieldWidget(
                                        focusNode: codeFocusNode,
                                        label: 'Verification code',
                                        labelColor: colorScheme.onBackground,
                                        placeHolder: 'eg. 123456',
                                        validator: isRequired,
                                        borderColor: colorScheme.outline,
                                        onSaved: (value) => code = value,
                                        placeHolderColor: colorScheme.onSurface,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Builder(builder: (ctx) {
                                        return CustomButtonWidget(
                                          text: 'Verify',
                                          expand: true,
                                          // disabled: true,
                                          loading: authState.status == AuthStatus.resendEmailInProgress || authState.status == AuthStatus.authorizeEmailInProgress,
                                          appearance: ButtonAppearance.secondary,
                                          onPressed: () => _onSubmitVerificationCodeTapped(ctx),
                                        );
                                      }),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                        onTap: _onResendVerificationCodeTapped,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Didn\'t get the code? ',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(color: colorScheme.onBackground),
                                              children:  [
                                                if(authState.status == AuthStatus.resendEmailInProgress) ... {

                                                  const WidgetSpan(child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                    child: CustomAdaptiveCircularIndicator(size: 16, ),
                                                  ))

                                                }else ... {

                                                  TextSpan(
                                                      text: 'Resend link',
                                                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold
                                                      )),

                                                }

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ))),
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

}
