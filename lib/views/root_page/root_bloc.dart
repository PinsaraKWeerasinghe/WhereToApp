import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/model/user.dart';
import 'package:whereto/db/repo/user_repository.dart';

import 'root_event.dart';
import 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  static final log = Logger();
  StreamSubscription _roleSubscription;
  final userRepo = UserRepository();

  RootBloc(BuildContext context);

  @override
  RootState get initialState => RootState(
        error: '',
        page: RootState.LOADING_PAGE,
        user: null,
        passcode: false,
      );

  @override
  Stream<RootState> mapEventToState(RootEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case InitialUserEvent:
        final email = (event as InitialUserEvent).email;
        yield state.clone(
          page: RootState.HOME_PAGE,
        );
        break;
      case ChangeUser:
        yield state.clone(
          user: (event as ChangeUser).user,
        );
        break;
      case LogInEvent:
        yield state.clone(page: RootState.LOGIN_PAGE);
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

  void _getRoles(final String email, Function(List<User>) callback) {
    _roleSubscription?.cancel();
    _roleSubscription = userRepo
        .query(
          specification: ComplexSpecification(
            [
              ComplexWhere(User.EMAIL_FIELD, isEqualTo: email),
            ],
          ),
        )
        .listen(
          callback,
        );
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
