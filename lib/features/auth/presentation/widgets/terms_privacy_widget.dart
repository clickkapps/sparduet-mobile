import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/mixin/launch_external_app_mixin.dart';
import 'package:sparkduet/network/api_routes.dart';

class TermsPrivacyWidget extends StatelessWidget with LaunchExternalAppMixin{

  final Function()? onTap;
  final Color? textColor;
  const TermsPrivacyWidget({
    this.textColor,
    this.onTap, super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap ?? () => _onReadTermsAndConditionsTapped(context),
      child: RichText(
        textAlign: TextAlign.center,
        text:  TextSpan(
          text: 'By clicking ',
          style: theme.textTheme.bodySmall?.copyWith(color: textColor ?? AppColors.white),
          children:  <TextSpan>[
            const TextSpan(text: '“Continue with Email/Gmail/Apple” above, you acknowledge that you have read and understood, and agree to Hook’s '),
            TextSpan(text: 'Terms of Use ',style: TextStyle(
              decoration: TextDecoration.underline,
              color: textColor ?? AppColors.white,
              decorationColor: AppColors.white,
            ),),
            const TextSpan(text: 'and '),
            TextSpan(text: 'Privacy policy', style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.white,
              color: textColor ?? AppColors.white,
            ),)
            // TextSpan(text: 'Continue', style: TextStyle(fontWeight: FontWeight.bold, color: kAppBlue)),
          ],
        ),
      ),
    );
  }


  /// when read terms and conditions tapped
  void _onReadTermsAndConditionsTapped(BuildContext context){
    launchBrowser(AppApiRoutes.aboutUrl, context);
  }
}
