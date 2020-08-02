import 'package:flutter/material.dart';

@immutable
abstract class SearchTabEvent {}

class ErrorEvent extends SearchTabEvent {
  final String error;

  ErrorEvent(this.error);
}


