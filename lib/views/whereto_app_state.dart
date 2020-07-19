import 'package:flutter/material.dart';

@immutable
class WhereToAppState {
  final String error;
  final String email;

  WhereToAppState({
    @required this.error,
    @required this.email,
  });

  WhereToAppState clone({
    String error,
    String email,
  }) {
    return WhereToAppState(
      error: error ?? this.error,
      email: email ?? this.email,
    );
  }
}
