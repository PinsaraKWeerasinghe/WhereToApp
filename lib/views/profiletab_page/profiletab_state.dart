import 'package:flutter/material.dart';

@immutable
class ProfileTabState {
  final String error;

  ProfileTabState({
    @required this.error,
  });

  ProfileTabState clone({
    String error,
  }) {
    return ProfileTabState(
      error: error ?? this.error,
    );
  }
}
