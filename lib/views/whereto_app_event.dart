import 'package:flutter/material.dart';

@immutable
abstract class WhereToAppEvent {}

class ErrorEvent extends WhereToAppEvent {
  final String error;

  ErrorEvent(this.error);
}

class UserLoggedEvent extends WhereToAppEvent {
  final String email;

  UserLoggedEvent(this.email);
}
