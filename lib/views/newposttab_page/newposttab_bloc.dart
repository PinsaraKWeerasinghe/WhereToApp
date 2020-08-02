import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/repo/Posts_repository.dart';

import 'newposttab_event.dart';
import 'newposttab_state.dart';

class NewPostTabBloc extends Bloc<NewPostTabEvent, NewPostTabState> {
  static final log = Logger();
  final picker = ImagePicker();
  final _postsRepository = PostsRepository();

  NewPostTabBloc(BuildContext context);

  @override
  NewPostTabState get initialState => NewPostTabState(
        error: '',
        imagePath: null,
      );

  @override
  Stream<NewPostTabState> mapEventToState(NewPostTabEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;

      case TakeImageEvent:
        String _imagePath = await _takeImage();
        yield state.clone(imagePath: _imagePath);
        break;
      case PostPublishEvent:
        final placeName = (event as PostPublishEvent).placeName;
        final description = (event as PostPublishEvent).description;
        final image = (event as PostPublishEvent).image;
        final username=((event as PostPublishEvent)).username;
        String downloadURL=await _postsRepository.uploadImageForPost(image);
        await _postsRepository.updatePostToDB(placeName,description,downloadURL,username);
        yield state.clone();
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
