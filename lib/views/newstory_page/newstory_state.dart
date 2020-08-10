import 'package:flutter/material.dart';

@immutable
class NewStoryState {
  final String error;
  final String storyImagePath;
  final bool successfulPublish;

  NewStoryState({
    @required this.error,
    @required this.storyImagePath,
    @required this.successfulPublish,
  });

  NewStoryState clone(
      {String error, String storyImagePath, bool successfulPublish}) {
    return NewStoryState(
      error: error ?? this.error,
      storyImagePath: storyImagePath ?? this.storyImagePath,
      successfulPublish: successfulPublish ?? this.successfulPublish,
    );
  }
}
