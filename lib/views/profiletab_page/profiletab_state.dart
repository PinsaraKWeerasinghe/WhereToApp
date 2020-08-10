import 'package:flutter/material.dart';

@immutable
class ProfileTabState {
  final String error;
  final bool enableEditing;
  final String imagePath;
  final bool profileSaved;

  ProfileTabState({
    @required this.error,
    @required this.enableEditing,
    @required this.imagePath,
    @required this.profileSaved,
  });

  ProfileTabState clone({
    String error,
    bool enableEditing,
    String imagePath,
    bool profileSaved,
  }) {
    return ProfileTabState(
      error: error ?? this.error,
      enableEditing: enableEditing ?? this.enableEditing,
      imagePath: imagePath ?? this.imagePath,
      profileSaved: profileSaved ?? this.profileSaved,
    );
  }
}
