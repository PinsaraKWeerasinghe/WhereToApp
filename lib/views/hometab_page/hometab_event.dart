import 'package:flutter/material.dart';

@immutable
abstract class HomeTabEvent {}

class ErrorEvent extends HomeTabEvent {
  final String error;

  ErrorEvent(this.error);
}