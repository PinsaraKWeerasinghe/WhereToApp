import 'package:flutter/material.dart';

@immutable
class HomeTabState {
  final String error;

  HomeTabState({
    @required this.error,
  });

  HomeTabState clone({
    String error,
  }) {
    return HomeTabState(
      error: error ?? this.error,
    );
  }
}
