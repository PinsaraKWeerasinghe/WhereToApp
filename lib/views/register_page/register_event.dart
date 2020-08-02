import 'package:flutter/material.dart';

@immutable
abstract class RegisterEvent {}

class ErrorEvent extends RegisterEvent {
  final String error;

  ErrorEvent(this.error);
}

class ToggleShowPasswordEvent extends RegisterEvent {
  final bool value;

  ToggleShowPasswordEvent(this.value);
}

class UserRegisterEvent extends RegisterEvent{
  final String name;
  final String username;
  final String password;
  final String email;

  UserRegisterEvent(this.name, this.username, this.password, this.email);

}
