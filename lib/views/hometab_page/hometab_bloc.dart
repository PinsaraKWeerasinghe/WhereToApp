import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/model/Post.dart';
import 'package:whereto/db/model/Story.dart';
import 'package:whereto/db/repo/Stories_repository.dart';
import 'package:whereto/util/assets.dart';

import 'hometab_event.dart';
import 'hometab_state.dart';

class HomeTabBloc extends Bloc<HomeTabEvent, HomeTabState> {
  static final log = Logger();
  final StoriesRepository _storiesRepository = new StoriesRepository();

  HomeTabBloc(BuildContext context);

  @override
  HomeTabState get initialState => HomeTabState(
        error: '',
        stories: new List(),
        posts: new List(),
      );

  @override
  Stream<HomeTabState> mapEventToState(HomeTabEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
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
}
