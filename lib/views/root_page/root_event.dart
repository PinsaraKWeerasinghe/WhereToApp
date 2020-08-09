import 'package:flutter/material.dart';
import 'package:whereto/db/model/user.dart';

@immutable
abstract class RootEvent {}

class ErrorEvent extends RootEvent {
  final String error;

  ErrorEvent(this.error);
}

class InitialEvent extends RootEvent {}

class LogOutEvent extends RootEvent {}

class LogInEvent extends RootEvent {}

class ChangeUser extends RootEvent {
  final User user;

  ChangeUser(this.user);
}

class InitialUserEvent extends RootEvent {
  final String email;

  InitialUserEvent(this.email);
}
