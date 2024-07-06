import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/auth/data/store/auth_state.dart';
import 'package:sparkduet/features/auth/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/enums.dart';
import 'package:sparkduet/features/feeds/data/store/feed_state.dart';
import 'package:sparkduet/features/feeds/data/store/stories_feeds_cubit.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';

import '../../../../network/api_routes.dart';

class AuthUserLocationPage extends StatelessWidget {

  final ScrollController? controller;
  final Function()? onComplete;
  final bool automaticallyImplyLeading;
  final bool fetchFeedsOnSuccess;
  const AuthUserLocationPage({super.key, this.controller, this.onComplete, this.automaticallyImplyLeading = false, this.fetchFeedsOnSuccess = false});

  void authCubitStateListener(BuildContext context, AuthState event) async {
    if(event.status == AuthStatus.setupAuthUserLocationFailed) {
      context.showSnackBar(event.message);
    }
    if(event.status == AuthStatus.setupAuthUserLocationSuccessful) {

      if(fetchFeedsOnSuccess) {
        const path = AppApiRoutes.feeds;
        final queryParams = { "page": 1, "limit": 20 };
        await context.read<StoriesFeedsCubit>().fetchFeeds(path: path, pageKey: 1, queryParams: queryParams);
      }

      if(onComplete != null) {
        onComplete?.call();
        return;
      }

      if(context.mounted) {
        context.go(AppRoutes.home);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: automaticallyImplyLeading ? const CloseButton() : null,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Lottie.asset(AppAssets.kLocationRequestJson, height: media.size.height * 0.3),
            const SizedBox(height: 15,),
            Text("Location Access for Personalization", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),),
            const SizedBox(height: 10,),
            //const Icon(Icons.check_circle, size: 20, color: Colors.green,)
            Text('Allow location access for a smoother, personalized app experience. This helps tailor features and content to your specific needs and preferences', style: theme.textTheme.bodyMedium?.copyWith(height: 1.5), textAlign: TextAlign.center,),
            const SizedBox(height: 15,),
            BlocBuilder<StoriesFeedsCubit, FeedState>(
              builder: (context, feedState) {
                return BlocConsumer<AuthCubit, AuthState>(
                  listener: authCubitStateListener,
                  builder: (context, authState) {
                    return CustomButtonWidget(text: "Alright!", onPressed: () {
                      context.read<AuthCubit>().setupAuthUserLocation();
                      // request location and go back to home page
                    }, expand: true,
                      loading:
                      authState.status == AuthStatus.setupAuthUserLocationInProgress
                      || (fetchFeedsOnSuccess && feedState.status == FeedStatus.fetchFeedsInProgress)
                      ,);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
