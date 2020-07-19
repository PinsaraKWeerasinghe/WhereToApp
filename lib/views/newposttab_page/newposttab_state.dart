import 'package:flutter/material.dart';

@immutable
class NewPostTabState {
  final String error;

  NewPostTabState({
    @required this.error,
  });

  NewPostTabState clone({
    String error,
  }) {
    return NewPostTabState(
      error: error ?? this.error,
    );
  }
}
