import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'searchtab_event.dart';
import 'searchtab_state.dart';

class SearchTabBloc extends Bloc<SearchTabEvent, SearchTabState> {
  static final log = Logger();

  SearchTabBloc(BuildContext context);

  @override
  SearchTabState get initialState => SearchTabState(
        error: '',
      );

  @override
  Stream<SearchTabState> mapEventToState(SearchTabEvent event) async* {
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
        (e is String) ? e : (e.message ?? "Something went wrong. Please try again !"),
      ));
    } catch (e) {
      add(ErrorEvent("Something went wrong. Please try again !"));
    }
  }
}