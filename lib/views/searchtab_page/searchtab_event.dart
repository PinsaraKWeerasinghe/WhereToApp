import 'package:flutter/material.dart';
import 'package:whereto/db/model/user.dart';

@immutable
abstract class SearchTabEvent {}

class ErrorEvent extends SearchTabEvent {
  final String error;

  ErrorEvent(this.error);
}

class ShowProfileEvent extends SearchTabEvent {
  final User user;
  final bool showProfile;

  ShowProfileEvent(this.user, this.showProfile);
}
