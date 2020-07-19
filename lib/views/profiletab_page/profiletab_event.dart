import 'package:flutter/material.dart';

@immutable
abstract class ProfileTabEvent {}

class ErrorEvent extends ProfileTabEvent {
  final String error;

  ErrorEvent(this.error);
}
