import 'package:flutter/material.dart';

@immutable
abstract class NewPostTabEvent {}

class ErrorEvent extends NewPostTabEvent {
  final String error;

  ErrorEvent(this.error);
}
