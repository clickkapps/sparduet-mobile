import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:separated_column/separated_column.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/core/app_classes.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_enums.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_close_bar.dart';
import 'package:sparkduet/utils/custom_fade_in_page_route.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

extension StringExtension on String? {

  String capitalize() {
    assert(this != null);

    return this!
        .split(' ')
        .map(
            (str) {
          if(str.length > 1) {
            return str[0].toUpperCase() + str.substring(1);
          } else {
            return str;
          }

        })
        .join(' ');
  }

  bool isNullOrEmpty() => this == null || this!.isEmpty;

}

extension ContextExtension on BuildContext {

  /// shows a [SnackBar]
  void showSnackBar(String message, {Color? background, Color? foreground, NotificationAppearance? appearance, BuildContext? context, Function()? onTap}) {
    Future.delayed(const Duration(milliseconds: 0), () async {
      try{

        final theme = Theme.of(this);
        Color backgColor = theme.colorScheme.primary.withOpacity(0.9);
        Color msgColor = theme.colorScheme.onPrimary;
        if(appearance == NotificationAppearance.error) {
          backgColor = Colors.redAccent;
          msgColor = Colors.white;
        }else if (appearance == NotificationAppearance.dark ) {
          backgColor = AppColors.black;
        }
        else if (appearance == NotificationAppearance.info ) {
          backgColor = AppColors.buttonBlue;
        }

        await Flushbar(
          titleColor: msgColor,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          message: message.isNotEmpty ? message : "Sorry, Please try again later",
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          // forwardAnimationCurve: Curves.elasticOut,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: background ?? backgColor,
          messageColor: msgColor,
          isDismissible: true,
          onTap: (flashBar) {
            onTap?.call();
          },
          borderColor: null,
          duration: const Duration(seconds: 4),
          icon: Icon(
            Icons.info_outline,
            color: msgColor,
          ),
        ).show(context ?? this);

      }catch(e){
        debugPrint("snackBar error: $e");
      }
    });
  }

  popScreen<T extends Object?>([T? result]){
    Navigator.of(this).pop(result);
  }

  // Handy method to show bottom sheets with ease
  Future<void> showCustomBottomSheet({required Widget child, bool? showDragHandle, Color? backgroundColor, double? elevation, BorderRadius? borderRadius, bool enableBottomPadding = true, bool isDismissible = true}){
    final theme = Theme.of(this);
    return showModalBottomSheet<void>(
      enableDrag: true,
      context: this,
      shape:  RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      elevation: elevation,
      showDragHandle: showDragHandle,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      isScrollControlled: true,
      isDismissible: isDismissible,
      builder: (BuildContext ctx) {
        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: !enableBottomPadding ? child : Padding(padding: EdgeInsets.only(
              bottom:  MediaQuery.of(ctx).viewInsets.bottom
          ),
            child: child,
          ),
        );
      },
    );
  }

  Future<Object?> pushScreen( Widget classObject,
      {bool replaceAll = false,
        fullscreenDialog = false,
        rootNavigator = false,
        bool fadeIn = false,
        dynamic args = const {}}) {
    if (replaceAll) {
      return Navigator.of(this, rootNavigator: rootNavigator)
          .pushAndRemoveUntil(
        fadeIn ?
        CustomFadeInPageRoute(classObject, color: AppColors.darkColorScheme.background)
            : MaterialPageRoute(
            builder: (context) => classObject,
            settings: RouteSettings(arguments: args)),
            (Route<dynamic> route) => false,
      );
    } else {
      return Navigator.of(this, rootNavigator: rootNavigator).push(
          fadeIn ?
          CustomFadeInPageRoute(classObject, color: AppColors.darkColorScheme.background)
              : MaterialPageRoute(
              builder: (context) => classObject,
              fullscreenDialog: fullscreenDialog,
              settings: RouteSettings(arguments: args)));
    }
  }

  void showConfirmDialog(BuildContext context,
      {required VoidCallback onConfirmTapped,
        VoidCallback? onCancelTapped,
        required String title,
        bool showCancelButton = true,
        bool isDismissible = true,
        bool showCloseButton = true,
        String? subtitle,
        int? subTitleMaxLines,
        Map<String, dynamic> data = const {},
        String? confirmAction,
        Widget? child,
        Color? backgroundColor,
        String? cancelAction}) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: isDismissible,
        // backgroundColor: .colorScheme.background,
        backgroundColor: theme.brightness == Brightness.light ? const Color(0xffF2F3F4) : const Color(0xff202021),
        context: context,
        shape:  const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom),
                color: backgroundColor,
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (showCloseButton) ...{
                        Align(
                          alignment: Alignment.topRight,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: GestureDetector(
                                onTap: () {
                                  pop(context);
                                },
                                child: ColoredBox(
                                    color: theme.brightness == Brightness.light ? const Color(0xffc2c2c2) : theme.colorScheme.outline,
                                    child:  SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Center(
                                            child: Icon(Icons.close, size: 20, color: theme.colorScheme.background,)))),
                              )
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: CloseButton(
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //   ),
                        // ),
                        // const CustomBorderWidget(),
                      },
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        title,
                        style: theme.textTheme.titleLarge,
                      ),
                      if (subtitle != null) ...{
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          subtitle,
                          style:
                          TextStyle(color: theme.colorScheme.onSurface),
                          maxLines: subTitleMaxLines,
                        ),
                      },
                      if (child != null) ...{
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: child,
                        ),
                      },
                      const SizedBox(
                        height: 20,
                      ),
                      SeparatedRow(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 10,);
                        },
                        children: [
                          if (showCancelButton) ...[
                            Expanded(
                                child: CustomButtonWidget(
                                  text: cancelAction ?? "Cancel",
                                  expand: true,
                                  appearance: ButtonAppearance.error,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    onCancelTapped?.call();
                                  },
                                )),
                          ],
                          Expanded(
                              child: CustomButtonWidget(
                                text: confirmAction ?? "Confirm",
                                expand: true,
                                appearance: ButtonAppearance.primary,
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  onConfirmTapped();

                                  // switch(action) {
                                  //   case DialogAction.deleteThread:
                                  //     state._deleteThread(data);
                                  //     break;
                                  //   case DialogAction.logout:
                                  //     state._logout();
                                  //     break;
                                  //   default:
                                  //     break;
                                  // }
                                },
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Method called when user wants to upload new set image images
  /// This will retrain the images
  void pickFilesFromGallery(
      {required RequestType requestType, Function(List<File>?)? onSuccess , Function(String)? onError,  int? maxAssets}) async {

    /// Check if user has granted the permissions to gallery
    await Permission.storage.request();
    await Permission.photos.request();

    bool photosPermissionStatus = false;
    if(Platform.isIOS) {
      PermissionStatus status = await Permission.photos.status;
      photosPermissionStatus = status.isGranted  || status.isLimited;
    }else {
      // android
      PermissionStatus storageStatus = (await Permission.storage.status);
      PermissionStatus photosStatus = (await Permission.photos.status);
      photosPermissionStatus = photosStatus.isGranted || storageStatus.isGranted;
    }

    if (!photosPermissionStatus) {

      if(!mounted) {
        onError?.call("Oops!. Sorry try again");
        return;
      }

      // Either the permission was already granted before or the user just granted it.
      showConfirmDialog(this, onConfirmTapped: (){
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enables it in the system settings.
        openAppSettings();
      },
          showCancelButton: false,
          title: "Photos permission required",
          subtitle: "Kindly grant access to your photos / gallery to proceed with your ProShots",
          confirmAction:  "Go to settings"
      );
      return;
    }

    if(!mounted) {
      onError?.call("Oops!. Sorry try again");
      return;
    }

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      this,
      pickerConfig: AssetPickerConfig(
        // themeColor: luckyPointBlue,
        requestType: requestType,
        maxAssets: maxAssets ?? (requestType == RequestType.video ? 1 : 10),

      ),
    );

    if(result == null) {
      onError?.call("Oops!. Sorry try again");
      return;
    }

    // final files = await result?.map((e) async => await e.file).toList();
    final List<File> files = [];

    for(int i = 0; i < result.length; i++){
      final file = await result[i].file;
      if(file == null) {
        continue;
      }
      files.add(file);
    }

    if(!mounted || files.isEmpty) {
      onError?.call("Oops!. Sorry try again");
      return;
    }

    // upload images / videos
    if(requestType == RequestType.video) {
      onSuccess?.call(<File>[files.first]);
    }else {
      onSuccess?.call(files);
    }

  }

  void pickFileFromCamera({required RequestType requestType, Function(File)? onSuccess, bool shouldAutoPreview = true, Function(String)? onError}) async {

    final AssetEntity? entity = await CameraPicker.pickFromCamera(this,
      pickerConfig: CameraPickerConfig(
        enableRecording: true,
        enableTapRecording: true,
        onlyEnableRecording: requestType == RequestType.video,
        textDelegate: const EnglishCameraPickerTextDelegate(),
        shouldAutoPreviewVideo: shouldAutoPreview
        // shouldAutoPreviewVideo: true,
        // maximumRecordingDuration:  Duration(seconds: AppConstants.maximumVideoDuration.toInt()),
        // minimumRecordingDuration:  Duration(seconds: AppConstants.minimumVideoDuration.toInt()),

      ),
    );

    final file = await entity?.file;
    if(file == null) {
      onError?.call("Oop! We were unable to capture video");
      return;
    }

    onSuccess?.call(file);

  }

  void showCustomListBottomSheet({required List<ListItem> items, Function(ListItem)? onItemTapped}) {

    final theme = Theme.of(this);

    final ch = ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: theme.colorScheme.background,
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const CustomCloseBar(),

              const SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.surface
                ),
                child: SeparatedColumn(
                  mainAxisSize: MainAxisSize.min,
                  separatorBuilder: (BuildContext context, int index) {
                    return const CustomBorderWidget();
                  },
                  children: [

                    ...items.map((item) {
                      return ListTile(title: Text(item.title, style: theme.textTheme.bodyMedium), onTap: () {
                        pop();
                        onItemTapped?.call(item);
                      }, trailing: item.icon != null ? Icon(item.icon, color: theme.colorScheme.onBackground) : null,);
                    })


                    // ListTile(title: Text("Select video from gallery", style: theme.textTheme.bodyMedium), onTap: () {
                    //   context.pop();
                    //
                    // }, trailing: Icon(FeatherIcons.image, color: theme.colorScheme.onBackground,),)
                    // ListTile(title: Text("Asian", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Asian";
                    //
                    // },),
                    // ListTile(title: Text("Black or African American", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Black or African American";
                    //
                    // },),
                    // ListTile(title: Text("Middle Eastern or North African", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Middle Eastern or North African";
                    //
                    // },),
                    // ListTile(title: Text("Native Hawaiian or other Pacific Islander", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Native Hawaiian or other Pacific Islander";
                    // },),
                    // ListTile(title: Text("White", style: theme.textTheme.bodyMedium,), onTap: () {
                    //   pop(context);
                    //   raceController.text = "White";
                    // },),
                    // ListTile(title: Text("Some other race", style: theme.textTheme.bodyMedium), onTap: () {
                    //   pop(context);
                    //   raceController.text = "Some other race";
                    // },),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
    showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)));

  }

}

extension EitherX<L, R> on Either<L, R> {
  R asRight() => (this as Right).value; //
  L asLeft() => (this as Left).value;
}


extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }
}