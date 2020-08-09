import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/repo/Stories_repository.dart';

import 'newstory_event.dart';
import 'newstory_state.dart';

class NewStoryBloc extends Bloc<NewStoryEvent, NewStoryState> {
  static final log = Logger();
  final StoriesRepository _storiesRepository = new StoriesRepository();
  final picker = ImagePicker();

  NewStoryBloc(BuildContext context);

  @override
  NewStoryState get initialState => NewStoryState(
        error: '',
    storyImagePath: null,
    successfulPublish: false,
      );

  @override
  Stream<NewStoryState> mapEventToState(NewStoryEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case TakeStoryImageEvent:
        String _imagePath = await _takeImage();
        yield state.clone(storyImagePath: _imagePath);
        break;
      case StoryPublishEvent:
        final image = (event as StoryPublishEvent).image;
        final username = ((event as StoryPublishEvent)).username;
        String downloadURL =
            await _storiesRepository.uploadImageForStory(image);
        await _storiesRepository.updateStoryToDB(downloadURL, username);
        yield state.clone(successfulPublish: true);
        break;
    }
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    log.e('$error');
    log.e('$stacktrace');
    _addErr(error);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void _addErr(e) {
    log.e('$e');
    try {
      add(ErrorEvent(
        (e is String)
            ? e
            : (e.message ?? "Something went wrong. Please try again !"),
      ));
    } catch (e) {
      add(ErrorEvent("Something went wrong. Please try again !"));
    }
  }

  Future<String> _takeImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return pickedFile.path;
  }
}
