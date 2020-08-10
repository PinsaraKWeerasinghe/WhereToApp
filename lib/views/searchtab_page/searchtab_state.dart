import 'package:flutter/material.dart';
import 'package:whereto/db/model/user.dart';

@immutable
class SearchTabState {
  final String error;
  final User user;
  final bool showProfile;

  SearchTabState({
    @required this.error,
    @required this.user,
    @required this.showProfile,
  });

  SearchTabState clone({
    String error,
    User user,
    bool showProfile,
  }) {
    return SearchTabState(
      error: error ?? this.error,
      user: user ?? this.user,
      showProfile: showProfile ?? this.showProfile,
    );
  }
}
