import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sparkduet/features/theme/data/store/enums.dart';

part 'theme_state.g.dart';

@CopyWith()
class ThemeState extends Equatable {

  final ThemeStatus status;
  final String message;
  final ThemeData? themeData;
  final AppFont appFont;

  const ThemeState({
    this.status = ThemeStatus.initial,
    this.message = "",
    this.themeData,
    this.appFont = AppFont.quicksand
  });

  @override
  List<Object?> get props => [status, themeData];

}