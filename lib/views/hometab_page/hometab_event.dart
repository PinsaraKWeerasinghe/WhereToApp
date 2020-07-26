import 'package:flutter/material.dart';

@immutable
abstract class HomeTabEvent {}

class ErrorEvent extends HomeTabEvent {
  final String error;

  ErrorEvent(this.error);
}

class LoadStoriesEvent extends HomeTabEvent {
  LoadStoriesEvent();
}

class LoadPostsEvent extends HomeTabEvent {
  LoadPostsEvent();
}
