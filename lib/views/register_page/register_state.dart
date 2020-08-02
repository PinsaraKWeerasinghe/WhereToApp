import 'package:flutter/material.dart';

@immutable
class RegisterState {
  final String error;
  final bool showPassword;

  RegisterState({
    @required this.error,
    @required this.showPassword,
  });

  RegisterState clone({
    String error,
    bool showPassword,
  }) {
    return RegisterState(
      error: error ?? this.error,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
