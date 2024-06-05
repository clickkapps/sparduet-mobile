import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/network/api_routes.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';


class AuthorizeSocialPage extends StatefulWidget {

  final String loginType ;
  final Function(String, String) onSuccess;
  const AuthorizeSocialPage({super.key, required this.loginType, required this.onSuccess});

  @override
  State<AuthorizeSocialPage> createState() => _AuthorizeSocialPageState();
}

class _AuthorizeSocialPageState extends State<AuthorizeSocialPage> {

  bool isLoading = true;
  final _key = UniqueKey();
  late String url;
  // here we checked the url state if it loaded or start Load or abort Load
  late WebViewController _webViewController;
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    url = '${AppApiRoutes.webApiUrl}/auth/social?provider=${widget.loginType}';
    _themeCubit = context.read<ThemeCubit>();
    _themeCubit.setSystemUIOverlaysToLight(androidSystemNavigationBarColor: AppColors.lightColorScheme.surface, androidStatusBarIconBrightness: Brightness.light);

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.lightColorScheme.surface)
      ..setUserAgent("random")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _webViewController.runJavaScript("javascript:document.body.style.marginTop=\"25%\"; void 0");
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(error.description);
            if(error.errorCode == -1009){
              context.showSnackBar('The Internet connection appears to be offline.', appearance:  NotificationAppearance.error);
              context.popScreen();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('url: ${request.url}');
            if(request.url.contains('token')) {

              //You can do anything
              _tokenRetrieved(request.url);
              //Prevent that url works
              return NavigationDecision.prevent;
            }
            //Any other url works
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    super.initState();
  }

  void _tokenRetrieved(String tokenUrl){
    final encoded = Uri.decodeFull(tokenUrl);

    Uri uri = Uri.parse(encoded);
    // Extracting query parameters
    Map<String, String> queryParams = uri.queryParameters;

    // Accessing values by keys
    String accessToken = queryParams['access_token'] ?? '';
    String customToken = queryParams['custom_token'] ?? '';

    widget.onSuccess(accessToken, customToken);
    if(mounted) {
      context.popScreen();
    }
  }



/// Build UI
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = AppColors.lightColorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
        bottom:  PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: CustomBorderWidget(color: AppColors.lightColorScheme.outline,)
        ),
        actions:  [
          UnconstrainedBox(
            child: CloseButton(color: colorScheme.onBackground,),
          ),
          const SizedBox(width: 15)

        ],

      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            width: mediaQuery.size.width,
            height: mediaQuery.size.height,
            child: WebViewWidget(
              key:  _key,
              controller: _webViewController,
            ),
          ),
          isLoading ? Container(
            color: colorScheme.surface,
            width: mediaQuery.size.width, height: mediaQuery.size.height,
            child: Center(
              child: SizedBox(width: 50, height: 50,
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: theme.colorScheme.primary, //const Color(0xff8280F7),
                        strokeWidth: 2,
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.favorite, color: theme.colorScheme.primary,)
                    )
                  ],
                ),
              ),
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
