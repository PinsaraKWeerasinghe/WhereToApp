import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'profiletab_event.dart';
import 'profiletab_state.dart';

class ProfileTabBloc extends Bloc<ProfileTabEvent, ProfileTabState> {
  static final log = Logger();

  ProfileTabBloc(BuildContext context);

  @override
  ProfileTabState get initialState => ProfileTabState(
        error: '',
      );

  @override
  Stream<ProfileTabState> mapEventToState(ProfileTabEvent event) async* {
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
