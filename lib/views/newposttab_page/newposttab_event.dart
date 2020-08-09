import 'package:flutter/material.dart';

@immutable
abstract class NewPostTabEvent {}

class ErrorEvent extends NewPostTabEvent {
  final String error;

  ErrorEvent(this.error);
}

class TakeImageEvent extends NewPostTabEvent {
  TakeImageEvent();
}

class PostPublishEvent extends NewPostTabEvent {
  final String placeName;
  final String description;
  final String image;
  final String username;

  PostPublishEvent(this.placeName, this.description, this.image, this.username);
}
