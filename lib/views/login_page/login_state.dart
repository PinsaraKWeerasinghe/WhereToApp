import 'package:flutter/material.dart';

@immutable
class LoginState {
  final String error;
  final String email;
  final bool showPassword;

  LoginState({
    @required this.error,
    @required this.email,
    @required this.showPassword,
  });

  LoginState clone({
    String error,
    String email,
    bool showPassword,
  }) {
    return LoginState(
      error: error ?? this.error,
      email: email ?? this.email,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
