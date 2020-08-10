import 'package:flutter/material.dart';

@immutable
abstract class NewStoryEvent {}

class ErrorEvent extends NewStoryEvent {
  final String error;

  ErrorEvent(this.error);
}


class TakeStoryImageEvent extends NewStoryEvent {
  final bool enableCamera;
  TakeStoryImageEvent(this.enableCamera);
}

class DeleteImageEvent extends NewStoryEvent {

  DeleteImageEvent();
}

class StoryPublishEvent extends NewStoryEvent {
  final String image;
  final String description;
  final String username;
  final String city;

  StoryPublishEvent(this.image,this.description, this.username,this.city);
}
