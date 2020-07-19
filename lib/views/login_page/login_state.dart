import 'package:flutter/material.dart';

@immutable
class LoginState {
  final String error;
  final String email;

  LoginState({
    @required this.error,
    @required this.email,
  });

  LoginState clone({
    String error,
    String email,
  }) {
    return LoginState(
      error: error ?? this.error,
      email: email ?? this.email,
    );
  }
}
