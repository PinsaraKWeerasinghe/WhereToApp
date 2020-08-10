import 'package:flutter/material.dart';

@immutable
class NewPostTabState {
  final String error;
  final String imagePath;
  final bool successfulPublish;

  NewPostTabState({
    @required this.error,
    @required this.imagePath,
    @required this.successfulPublish,
  });

  NewPostTabState clone({
    String error,
    String imagePath,
    bool successfulPublish,
  }) {
    return NewPostTabState(
      error: error ?? this.error,
      imagePath: imagePath ?? this.imagePath,
      successfulPublish: successfulPublish ?? this.successfulPublish,
    );
  }
}
