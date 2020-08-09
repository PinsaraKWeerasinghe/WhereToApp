import 'package:flutter/material.dart';

@immutable
class NewPostTabState {
  final String error;
  final String imagePath;

  NewPostTabState({
    @required this.error,
    @required this.imagePath,
  });

  NewPostTabState clone({
    String error,
    String imagePath,
  }) {
    return NewPostTabState(
      error: error ?? this.error,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
