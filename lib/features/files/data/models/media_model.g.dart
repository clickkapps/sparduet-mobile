// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MediaModelCWProxy {
  MediaModel path(String path);

  MediaModel type(FileType type);

  MediaModel assetId(String? assetId);

  MediaModel aspectRatio(String? aspectRatio);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MediaModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MediaModel(...).copyWith(id: 12, name: "My name")
  /// ````
  MediaModel call({
    String? path,
    FileType? type,
    String? assetId,
    String? aspectRatio,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMediaModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMediaModel.copyWith.fieldName(...)`
class _$MediaModelCWProxyImpl implements _$MediaModelCWProxy {
  const _$MediaModelCWProxyImpl(this._value);

  final MediaModel _value;

  @override
  MediaModel path(String path) => this(path: path);

  @override
  MediaModel type(FileType type) => this(type: type);

  @override
  MediaModel assetId(String? assetId) => this(assetId: assetId);

  @override
  MediaModel aspectRatio(String? aspectRatio) => this(aspectRatio: aspectRatio);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MediaModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MediaModel(...).copyWith(id: 12, name: "My name")
  /// ````
  MediaModel call({
    Object? path = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? assetId = const $CopyWithPlaceholder(),
    Object? aspectRatio = const $CopyWithPlaceholder(),
  }) {
    return MediaModel(
      path: path == const $CopyWithPlaceholder() || path == null
          ? _value.path
          // ignore: cast_nullable_to_non_nullable
          : path as String,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as FileType,
      assetId: assetId == const $CopyWithPlaceholder()
          ? _value.assetId
          // ignore: cast_nullable_to_non_nullable
          : assetId as String?,
      aspectRatio: aspectRatio == const $CopyWithPlaceholder()
          ? _value.aspectRatio
          // ignore: cast_nullable_to_non_nullable
          : aspectRatio as String?,
    );
  }
}

extension $MediaModelCopyWith on MediaModel {
  /// Returns a callable class that can be used as follows: `instanceOfMediaModel.copyWith(...)` or like so:`instanceOfMediaModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MediaModelCWProxy get copyWith => _$MediaModelCWProxyImpl(this);
}
