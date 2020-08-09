import 'package:flutter/material.dart';

@immutable
abstract class NewStoryEvent {}

class ErrorEvent extends NewStoryEvent {
  final String error;

  ErrorEvent(this.error);
}
class TakeStoryImageEvent extends NewStoryEvent {
  TakeStoryImageEvent();
}
class StoryPublishEvent extends NewStoryEvent {
  final String image;
  final String username;

  StoryPublishEvent(this.image, this.username);
}