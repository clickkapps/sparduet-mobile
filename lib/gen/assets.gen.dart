/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImgGen {
  const $AssetsImgGen();

  /// File path: assets/img/app_icon.png
  AssetGenImage get appIcon => const AssetGenImage('assets/img/app_icon.png');

  /// File path: assets/img/avatar.jpg
  AssetGenImage get avatarJpg => const AssetGenImage('assets/img/avatar.jpg');

  /// File path: assets/img/avatar.png
  AssetGenImage get avatarPng => const AssetGenImage('assets/img/avatar.png');

  /// File path: assets/img/premium_header_image.jpg
  AssetGenImage get premiumHeaderImage =>
      const AssetGenImage('assets/img/premium_header_image.jpg');

  /// File path: assets/img/splash_img.png
  AssetGenImage get splashImg =>
      const AssetGenImage('assets/img/splash_img.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [appIcon, avatarJpg, avatarPng, premiumHeaderImage, splashImg];
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/empty_chat.json
  String get emptyChat => 'assets/json/empty_chat.json';

  /// File path: assets/json/first_impression.json
  String get firstImpression => 'assets/json/first_impression.json';

  /// File path: assets/json/location_request.json
  String get locationRequest => 'assets/json/location_request.json';

  /// File path: assets/json/matched_coversations.json
  String get matchedCoversations => 'assets/json/matched_coversations.json';

  /// File path: assets/json/sub_success.json
  String get subSuccess => 'assets/json/sub_success.json';

  /// List of all assets
  List<String> get values => [
        emptyChat,
        firstImpression,
        locationRequest,
        matchedCoversations,
        subSuccess
      ];
}

class Assets {
  Assets._();

  static const String env = 'assets/.env';
  static const $AssetsImgGen img = $AssetsImgGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();

  /// List of all assets
  static List<String> get values => [env];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
