// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mux_commons_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuxTrackModel _$MuxTrackModelFromJson(Map<String, dynamic> json) =>
    MuxTrackModel(
      maxWidth: json['maxWidth'] as int?,
      type: json['type'] as String?,
      id: json['id'] as String?,
      duration: (json['duration'] as num?)?.toDouble(),
      maxFrameRate: (json['maxFrameRate'] as num?)?.toDouble(),
      maxHeight: json['maxHeight'] as int?,
      maxChannelLayout: json['maxChannelLayout'] as String?,
      maxChannels: json['maxChannels'] as int?,
    );

Map<String, dynamic> _$MuxTrackModelToJson(MuxTrackModel instance) =>
    <String, dynamic>{
      'maxWidth': instance.maxWidth,
      'type': instance.type,
      'id': instance.id,
      'duration': instance.duration,
      'maxFrameRate': instance.maxFrameRate,
      'maxHeight': instance.maxHeight,
      'maxChannelLayout': instance.maxChannelLayout,
      'maxChannels': instance.maxChannels,
    };

MuxPlaybackIdModel _$MuxPlaybackIdModelFromJson(Map<String, dynamic> json) =>
    MuxPlaybackIdModel(
      policy: json['policy'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$MuxPlaybackIdModelToJson(MuxPlaybackIdModel instance) =>
    <String, dynamic>{
      'policy': instance.policy,
      'id': instance.id,
    };

MuxDataModel _$MuxDataModelFromJson(Map<String, dynamic> json) => MuxDataModel(
      test: json['test'] as bool?,
      maxStoredFrameRate: (json['maxStoredFrameRate'] as num?)?.toDouble(),
      status: json['status'] as String?,
      tracks: (json['tracks'] as List<dynamic>?)
          ?.map((e) => MuxTrackModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
      maxStoredResolution: json['maxStoredResolution'] as String?,
      masterAccess: json['masterAccess'] as String?,
      playbackIds: (json['playbackIds'] as List<dynamic>?)
          ?.map((e) => MuxPlaybackIdModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      duration: (json['duration'] as num?)?.toDouble(),
      mp4Support: json['mp4Support'] as String?,
      aspectRatio: json['aspectRatio'] as String?,
    );

Map<String, dynamic> _$MuxDataModelToJson(MuxDataModel instance) =>
    <String, dynamic>{
      'test': instance.test,
      'maxStoredFrameRate': instance.maxStoredFrameRate,
      'status': instance.status,
      'tracks': instance.tracks?.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'maxStoredResolution': instance.maxStoredResolution,
      'masterAccess': instance.masterAccess,
      'playbackIds': instance.playbackIds?.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'duration': instance.duration,
      'mp4Support': instance.mp4Support,
      'aspectRatio': instance.aspectRatio,
    };

MuxAssetDataModel _$MuxAssetDataModelFromJson(Map<String, dynamic> json) =>
    MuxAssetDataModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MuxDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MuxAssetDataModelToJson(MuxAssetDataModel instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

MuxVideoDataModel _$MuxVideoDataModelFromJson(Map<String, dynamic> json) =>
    MuxVideoDataModel(
      data: json['data'] == null
          ? null
          : MuxDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MuxVideoDataModelToJson(MuxVideoDataModel instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
    };
