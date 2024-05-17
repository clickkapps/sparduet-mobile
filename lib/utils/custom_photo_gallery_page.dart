import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/theme/data/store/theme_cubit.dart';
import 'package:sparkduet/utils/custom_adaptive_circular_indicator.dart';
enum PhotoFileSource { url, file }
class CustomPhotoGalleryPage extends StatefulWidget {

  final List<String>? urls;
  final List<File>? files;
  final PhotoFileSource fileSource;
  final int initialPageIndex;
  final bool showProgressText;
  const CustomPhotoGalleryPage({super.key, required this.fileSource, this.urls, this.files, this.initialPageIndex = 0, this.showProgressText = true});

  @override
  State<CustomPhotoGalleryPage> createState() => _CustomPhotoGalleryPageState();
}

class _CustomPhotoGalleryPageState extends State<CustomPhotoGalleryPage>  with SingleTickerProviderStateMixin {


  late Brightness originalThemeBrightness;
  late ValueNotifier<int> currentIndex;
  late ValueNotifier<bool> enableSwipe;
  // late ValueNotifier<bool> enableDragToDismiss;
  late PageController _pageController;
  bool inFullScreen = false;
  late Animation<double> animation;
  late AnimationController animationController;
  final ValueNotifier<double> pageDismissProgress = ValueNotifier(1.0);
  late ThemeCubit themeCubit;


  @override
  void initState() {
    themeCubit = context.read<ThemeCubit>();
    themeCubit.setSystemUIOverlaysToDark();
    currentIndex = ValueNotifier(widget.initialPageIndex);
    enableSwipe = ValueNotifier(true);
    // enableDragToDismiss = ValueNotifier(true);
    _pageController = PageController(initialPage: widget.initialPageIndex);
    // _pageController.

    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds:  200), value: 1);
    final tween = Tween<double>(begin: 0.0, end: 1.0);
    animation = tween.animate(animationController);
    onWidgetBindingComplete(onComplete: () {
      originalThemeBrightness = Theme.of(context).brightness;
    });

    super.initState();
  }

  @override
  void dispose() {
    if(originalThemeBrightness == Brightness.light){
      themeCubit.setSystemUIOverlaysToLight();
    }
    disableFullScreen();
    _pageController.dispose();
    animationController.dispose();
    super.dispose();
  }


  Future<bool> dismissPage(BuildContext context, ThemeData theme) async {
    await disableFullScreen();
    // setAppSystemOverlay(theme: theme, useThemeOverlays: true, strictlyUseDarkModeOverlays: false, strictlyUseLightModeOverlays: false);
    if(context.mounted){
      context.popScreen();
    }
    return true;
  }


  void _onPageChanged(int index){
    currentIndex.value = index;
  }

  void _changeImage(int index){
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }



  /// Build UI
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    // setAppSystemOverlay(theme: theme, strictlyUseDarkModeOverlays: true, useThemeOverlays: false);

    return PopScope(
      onPopInvoked: (invoked) {
        if(invoked) {
           dismissPage(context, theme);
        }
      },
      child: ValueListenableBuilder<double>(
          valueListenable: pageDismissProgress,
          builder: (_, pageDismissProgress, __) {
            return Scaffold(
                backgroundColor: AppColors.darkColorScheme.background.withOpacity(pageDismissProgress),
                appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: AnimatedBuilder(
                  animation: animation,
                  builder: (_, ch) {
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: Opacity(opacity: animation.value, child: const BackButton(),),
                      iconTheme:  IconThemeData(color: AppColors.darkColorScheme.onBackground),
                      centerTitle: false,
                      title: Opacity(
                        opacity: animation.value,
                        child: widget.showProgressText ? ValueListenableBuilder(valueListenable: currentIndex, builder: (_, index, __) {
                          return Text("${index + 1} out of ${widget.fileSource == PhotoFileSource.url ? (widget.urls?.length ?? 0) : (widget.files?.length ?? 0)}", maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.darkColorScheme.onBackground),);
                        }) : const SizedBox.shrink(),
                      ),
                    );
                  },
                )),
              /// Images here --------------
                body: Platform.isIOS ?

                ValueListenableBuilder<bool>(valueListenable: enableSwipe, builder: (_, enableDragToDismissValue, ch) {
                  return Dismissible(
                      direction: enableDragToDismissValue ? DismissDirection.vertical : DismissDirection.none,
                      onDismissed: (_) {
                        dismissPage(context, theme);
                      },
                      onUpdate: (DismissUpdateDetails update) {
                        // update is between 0 and 1. update 1.0 means fully dismissed, 0.0 fully visible
                        // final progress = update.progress < 0.5 ? 0.5 : 0.0;


                        pageDismissProgress = 1 - update.progress;

                        // debugPrint("update: ${update.progress}");
                        if(update.progress == 0.0){
                          animationController.forward();
                          disableFullScreen();

                        }else{
                          if(!animationController.isAnimating) {
                            animationController.reverse();
                          }
                        }


                      },
                      behavior: HitTestBehavior.opaque,
                      key:  ValueKey("image-preview-${widget.fileSource == PhotoFileSource.url ? widget.urls![0] : widget.files!.first.path}"),
                      child: ch!
                  );

                }, child: SafeArea(
                  child: _pageView(context),
                ),) : SafeArea(
                  child: _pageView(context),
                ),

            );
          }
      ),
    );

  }


  Widget _pageView(BuildContext context) {
    return ValueListenableBuilder<bool>(valueListenable: enableSwipe, builder: (_, bool enableSwipeValue, __) {
      return PhotoViewGallery.builder(
        scrollPhysics: enableSwipeValue ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        scaleStateChangedCallback: (scale) {
          debugPrint("photoview: scale state changed: $scale");
          enableSwipe.value = scale == PhotoViewScaleState.initial;
        },

        builder: (BuildContext context, int index) {

          final imageUrl = widget.fileSource == PhotoFileSource.url ? widget.urls![index] : widget.files![index].path;

          // widget.fileSource == FileSource.url ?
          // late ImageProvider<Object> imageProvider;
          // if(widget.fileSource == FileSource.url)
          return PhotoViewGalleryPageOptions(

              imageProvider: (widget.fileSource == PhotoFileSource.url ?
              CachedNetworkImageProvider(
                imageUrl,
                cacheKey: imageUrl,
                // maxWidth: size.width.toInt(),
              ):
              FileImage(File(imageUrl))) as ImageProvider,

              initialScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
              onTapDown: (_, TapDownDetails details, ctrl){
                if(inFullScreen){
                  // disable full screen
                  disableFullScreen();
                }else{
                  // enable full screen
                  enableFullScreen();
                }
                inFullScreen = !inFullScreen;
              }
          );
        },
        itemCount: widget.fileSource == PhotoFileSource.url ? (widget.urls?.length ?? 0) : (widget.files?.length ?? 0),
        loadingBuilder: (context, event) => const Center(child: CustomAdaptiveCircularIndicator(),),
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        pageController: _pageController,
        onPageChanged: _onPageChanged,
      );
    });
  }



}
