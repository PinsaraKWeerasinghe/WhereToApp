import 'package:flutter/material.dart';
import 'package:whereto/db/model/user.dart';

@immutable
abstract class ProfileTabEvent {}

class ErrorEvent extends ProfileTabEvent {
  final String error;

  ErrorEvent(this.error);
}

class EnableEditModeEvent extends ProfileTabEvent {
  final bool enable;

  EnableEditModeEvent(this.enable);
}

class SaveProfileEvent extends ProfileTabEvent {
  final User user;

  SaveProfileEvent(this.user);
}
