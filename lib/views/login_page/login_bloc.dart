import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/authentication.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static final log = Logger();
  final _authentication = Authentication();

  LoginBloc(BuildContext context);

  @override
  LoginState get initialState => LoginState(
        error: '',
        email: '',
      );

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case UserLoginEvent:
        try{
          final email = (event as UserLoginEvent).email;
          final password = (event as UserLoginEvent).password;
          await _authentication.login(email, password);
          yield state.clone(email: email,error: '');
        } catch(e){
          try {
            add(ErrorEvent((e is String)
                ? e
                : (e.message ?? "Something went wrong. Please try again !")));
          } catch (e) {
            add(ErrorEvent("Something went wrong. Please try again !"));
          }
        }
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
