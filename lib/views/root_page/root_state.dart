import 'package:flutter/material.dart';
import 'package:whereto/db/model/user.dart';

@immutable
class RootState {
  static const LOADING_PAGE=1;
  static const LOGIN_PAGE=2;
  static const HOME_PAGE=3;

  final int page;
  final String error;
  final User user;
  final bool passcode;

  RootState({
    @required this.page,
    @required this.error,
    @required this.user,
    @required this.passcode,
  });

  RootState clone({
    int page,
    String error,
    User user,
    bool passcode,
  }) {
    return RootState(
      page: page ?? this.page,
      error: error ?? this.error,
      user: user ?? this.user,
      passcode: passcode ?? this.passcode,
    );
  }
}
