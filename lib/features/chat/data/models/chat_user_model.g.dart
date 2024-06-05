// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatUserModelCWProxy {
  ChatUserModel id(int? id);

  ChatUserModel name(String? name);

  ChatUserModel email(String? email);

  ChatUserModel username(String? username);

  ChatUserModel image(String? image);

  ChatUserModel unreadMessages(int unreadMessages);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatUserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatUserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatUserModel call({
    int? id,
    String? name,
    String? email,
    String? username,
    String? image,
    int? unreadMessages,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatUserModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatUserModel.copyWith.fieldName(...)`
class _$ChatUserModelCWProxyImpl implements _$ChatUserModelCWProxy {
  const _$ChatUserModelCWProxyImpl(this._value);

  final ChatUserModel _value;

  @override
  ChatUserModel id(int? id) => this(id: id);

  @override
  ChatUserModel name(String? name) => this(name: name);

  @override
  ChatUserModel email(String? email) => this(email: email);

  @override
  ChatUserModel username(String? username) => this(username: username);

  @override
  ChatUserModel image(String? image) => this(image: image);

  @override
  ChatUserModel unreadMessages(int unreadMessages) =>
      this(unreadMessages: unreadMessages);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatUserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatUserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatUserModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? username = const $CopyWithPlaceholder(),
    Object? image = const $CopyWithPlaceholder(),
    Object? unreadMessages = const $CopyWithPlaceholder(),
  }) {
    return ChatUserModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      username: username == const $CopyWithPlaceholder()
          ? _value.username
          // ignore: cast_nullable_to_non_nullable
          : username as String?,
      image: image == const $CopyWithPlaceholder()
          ? _value.image
          // ignore: cast_nullable_to_non_nullable
          : image as String?,
      unreadMessages: unreadMessages == const $CopyWithPlaceholder() ||
              unreadMessages == null
          ? _value.unreadMessages
          // ignore: cast_nullable_to_non_nullable
          : unreadMessages as int,
    );
  }
}

extension $ChatUserModelCopyWith on ChatUserModel {
  /// Returns a callable class that can be used as follows: `instanceOfChatUserModel.copyWith(...)` or like so:`instanceOfChatUserModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatUserModelCWProxy get copyWith => _$ChatUserModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserModel _$ChatUserModelFromJson(Map<String, dynamic> json) =>
    ChatUserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      image: json['image'] as String?,
      unreadMessages: json['unreadMessages'] as int? ?? 0,
    );

Map<String, dynamic> _$ChatUserModelToJson(ChatUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'unreadMessages': instance.unreadMessages,
    };
