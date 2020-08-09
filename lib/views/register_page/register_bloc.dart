import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/authentication.dart';
import 'package:whereto/db/repo/user_repository.dart';

import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  static final log = Logger();
  final _authentication = Authentication();
  final _userRepositery = UserRepository();

  RegisterBloc(BuildContext context);

  @override
  RegisterState get initialState => RegisterState(
        error: '',
        showPassword: false,
      );

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case ToggleShowPasswordEvent:
        yield state.clone(
            showPassword: (event as ToggleShowPasswordEvent).value);
        break;
      case UserRegisterEvent:
        final name = (event as UserRegisterEvent).name;
        final username = (event as UserRegisterEvent).username;
        final email = (event as UserRegisterEvent).email;
        final password = (event as UserRegisterEvent).password;
        _authentication
            .register(name, username, email, password)
            .whenComplete(() {
          _userRepositery.registerUsers(name, username, email);
        });
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
