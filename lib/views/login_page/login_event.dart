import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent {}

class ErrorEvent extends LoginEvent {
  final String error;

  ErrorEvent(this.error);
}

class UserLoginEvent extends LoginEvent {
  final String email;
  final String password;

  UserLoginEvent(this.email, this.password);
}
