import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/auth/presentation/pages/authorize_email_page.dart';
import 'package:sparkduet/features/auth/presentation/pages/authorize_social_page.dart';
import 'package:sparkduet/features/auth/presentation/widgets/terms_privacy_widget.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/mixin/form_mixin.dart';
import 'package:sparkduet/utils/custom_animated_column_widget.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_page_loading_overlay.dart';
import 'package:sparkduet/utils/custom_regular_video_widget.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';
// import 'package:video_viewer/video_viewer.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> with FormMixin {

  late AuthCubit _authCubit;
  late ThemeCubit _themeCubit;
  String? _email;
  late TextEditingController _emailController;
  final FocusNode emailFocusNode = FocusNode();
  ValueNotifier<bool> showSubmitEmailIcon = ValueNotifier(false);

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    _emailController = TextEditingController();
    _themeCubit = context.read<ThemeCubit>();
    onWidgetBindingComplete(onComplete: () {
      _themeCubit.setLightMode();
      _themeCubit.setSystemUIOverlaysToPrimary();
    });
    super.initState();
  }


  void _onEmailChanged(String value) {
    if(value.isEmpty) {
      showSubmitEmailIcon.value = false;
    }else{
      showSubmitEmailIcon.value = true;
    }
  }

  void _onEmailSubmitted(BuildContext ctx, _) async {

    emailFocusNode.unfocus();

    // email should not be null at this point
    if(!validateAndSaveOnSubmit(ctx)){ return;}

    if(_email.isNullOrEmpty()){ return; }

    _authCubit.submitEmail(email: _email!);

  }

  void authCubitListener(BuildContext ctx, AuthState authState) async {

    if(authState.status == AuthStatus.loginFailed){
      context.showSnackBar(authState.message, appearance: NotificationAppearance.error);
    }

    if(authState.status == AuthStatus.submitEmailFailed) {
      context.showSnackBar(authState.message, appearance: NotificationAppearance.error);
    }

    if(authState.status == AuthStatus.loginSuccessful) {
      // when authentication is successful
      context.go(AppRoutes.home);
    }

    if(authState.status == AuthStatus.submitEmailSuccessful) {

      if(_email != null){
        // when email is sent
        openAuthorizeEmailModal(ctx, email: _email ?? "");
      }

    }

  }

  void openAuthorizeEmailModal(BuildContext context, {required String email}) {

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
              child: AuthorizeEmailPage(email: email, onSuccess: (token) {
                _authCubit.login(token: token);
              },),
            );
          }
      ),
    );

    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) =>  _themeCubit.setSystemUIOverlaysToPrimary());

  }


  void openAuthorizeSocialModal(BuildContext context, {required String loginType}) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 1.0,
          minChildSize: 0.9,
          builder: (_ , controller) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(20)),
              child: AuthorizeSocialPage(loginType: loginType, onSuccess: (token) {
                _authCubit.login(token: token);
              },),
            );
          }
      ),
    );

    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), backgroundColor: Colors.transparent, enableBottomPadding: false).then((value) =>  _themeCubit.setSystemUIOverlaysToPrimary());
  }

  /// Build UI
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: authCubitListener,
      builder: (context, authState) {
        return CustomPageLoadingOverlay(
          loading: authState.status == AuthStatus.logInInProgress || authState.status == AuthStatus.submitEmailInProgress,
          child:
          Scaffold(
            backgroundColor: theme.colorScheme.primary,
            body: Stack(
              children: [
                CustomVideoPlayer(
                  networkUrl: "https://res.cloudinary.com/dhhyl4ygy/video/upload/f_auto:video,q_auto/v1/sparkduet/hl6is7u3aksdcg2gptgs.mp4",
                  autoPlay: true,
                  loop: true,
                  aspectRatio: mediaQuery.size.width / mediaQuery.size.height,
                  hls: false,
                  fit: BoxFit.cover,
                  videoSource: VideoSource.network,
                ),
                SafeArea(child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight),
                      // child: Image.asset(kAppLogoTextOnlyRed, scale: 4,),
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: 'SPARK',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.w800
                                    ),
                                    children:  [
                                      const TextSpan(text: ' '),
                                      TextSpan(
                                          text: 'DUET',
                                          style: TextStyle(color: theme.colorScheme.primary)
                                      )
                                    ]
                                ),
                              ),
                              Text("Everyone deserves love", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),)
                            ],
                          ),

                        ],
                      ),
                      // child: Text('HOOKS'),
                    )
                )
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.005),
                              theme.colorScheme.primary.withOpacity(0.5),
                              theme.colorScheme.primary,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          child: CustomAnimatedColumnWidget(
                            // runSpacing: 10,
                            // spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[

                              if(Platform.isIOS) ... {
                                CustomButtonWidget(text: ' Sign in with Apple  ',
                                  onPressed: () => openAuthorizeSocialModal(context, loginType: "apple"),
                                  appearance: ButtonAppearance.dark,
                                  icon: const Icon(FontAwesomeIcons.apple, color: Colors.white,),
                                  expand: true,
                                ),
                                const SizedBox(height: 10,),
                              },
                              CustomButtonWidget(text: 'Sign in with Google',
                                  expand: true,
                                  icon: const Icon(FontAwesomeIcons.google, size: 18, color: Colors.white,),
                                  onPressed: () => openAuthorizeSocialModal(context, loginType: "google"),
                                  appearance: ButtonAppearance.secondary  ),

                              const SizedBox(height: 10,),

                              CustomBorderWidget(centerText: 'OR', color: AppColors.white.withOpacity(0.8),),

                              const SizedBox(height: 10,),

                              Form(
                                child: Builder(
                                    builder: (ctx) {
                                      return CustomTextFieldWidget(
                                        controller: _emailController,
                                        label: 'Email',
                                        focusNode: emailFocusNode,
                                        borderColor: AppColors.white,
                                        placeHolder: 'email@example.com',
                                        labelColor: AppColors.white,
                                        inputType: TextInputType.emailAddress,
                                        placeHolderColor: AppColors.white.withOpacity(0.5),
                                        onSaved: (value) => _email = value,
                                        onChange: (value) =>  _onEmailChanged(value ?? ''),
                                        suffix: ValueListenableBuilder<bool>(
                                            valueListenable: showSubmitEmailIcon,
                                            builder: (ctx, value, _) {
                                              if(!value) return const SizedBox.shrink();
                                              return IconButton(
                                                onPressed: () => _onEmailSubmitted(ctx, _emailController.text),
                                                icon: const Icon(Icons.arrow_circle_right_outlined, color: AppColors.white,),
                                              );
                                            }
                                        ),
                                        onSubmitted: (value) => _onEmailSubmitted(ctx, value),
                                      );
                                    }
                                ),
                              ),

                              const SizedBox(height:20,),

                              AnimatedContainer(duration: const Duration(seconds: 3),
                                child: FadeIn(
                                  child: const TermsPrivacyWidget(),
                                ),
                              )

                              // if(mediaQuery.viewPadding.bottom > 0.0) ... {
                              //
                              // }

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
