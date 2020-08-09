import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'whereto_app_event.dart';
import 'whereto_app_state.dart';

class WhereToAppBloc extends Bloc<WhereToAppEvent, WhereToAppState> {
  static final log = Logger();

  WhereToAppBloc(BuildContext context);

  @override
  WhereToAppState get initialState => WhereToAppState(error: '', email: '');

  @override
  Stream<WhereToAppState> mapEventToState(WhereToAppEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case UserLoggedEvent:
        final email = (event as UserLoggedEvent).email;
        yield state.clone(email: email);
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
