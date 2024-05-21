import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mux_commons_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MuxTrackModel {

  MuxTrackModel({
    this.maxWidth,
    this.type,
    this.id,
    this.duration,
    this.maxFrameRate,
    this.maxHeight,
    this.maxChannelLayout,
    this.maxChannels,
  });

  final int? maxWidth;
  final String? type;
  final String? id;
  final double? duration;
  final double? maxFrameRate;
  final int? maxHeight;
  final String? maxChannelLayout;
  final int? maxChannels;

  factory MuxTrackModel.fromJson(Map<String, dynamic> json) => _$MuxTrackModelFromJson(json);
  Map<String, dynamic> toJson() => _$MuxTrackModelToJson(this);

}

@JsonSerializable(explicitToJson: true)
class MuxPlaybackIdModel {
  MuxPlaybackIdModel({
    this.policy,
    this.id,
  });

  final String? policy;
  final String? id;

  factory MuxPlaybackIdModel.fromJson(Map<String, dynamic> json) => _$MuxPlaybackIdModelFromJson(json);
  Map<String, dynamic> toJson() => _$MuxPlaybackIdModelToJson(this);

}

@JsonSerializable(explicitToJson: true)
class MuxDataModel {
  MuxDataModel({
    this.test,
    this.maxStoredFrameRate,
    this.status,
    this.tracks,
    this.id,
    this.maxStoredResolution,
    this.masterAccess,
    this.playbackIds,
    this.createdAt,
    this.duration,
    this.mp4Support,
    this.aspectRatio,
  });

  final bool? test;
  final double? maxStoredFrameRate;
  final String? status;
  final List<MuxTrackModel>? tracks;
  final String? id;
  final String? maxStoredResolution;
  final String? masterAccess;
  final List<MuxPlaybackIdModel>? playbackIds;
  final String? createdAt;
  final double? duration;
  final String? mp4Support;
  final String? aspectRatio;

  factory MuxDataModel.fromJson(Map<String, dynamic> json) => _$MuxDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$MuxDataModelToJson(this);

}

@JsonSerializable(explicitToJson: true)
class MuxAssetDataModel {
  MuxAssetDataModel({
    this.data,
  });
  final List<MuxDataModel>? data;

  factory MuxAssetDataModel.fromJson(Map<String, dynamic> json) => _$MuxAssetDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$MuxAssetDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MuxVideoDataModel {
  MuxVideoDataModel({
    this.data,
  });

  MuxDataModel? data;

  factory MuxVideoDataModel.fromJson(Map<String, dynamic> json) => _$MuxVideoDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$MuxVideoDataModelToJson(this);
}