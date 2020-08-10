import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/repo/user_repository.dart';
import 'package:whereto/util/db_util.dart';

import 'profiletab_event.dart';
import 'profiletab_state.dart';

class ProfileTabBloc extends Bloc<ProfileTabEvent, ProfileTabState> {
  static final log = Logger();
  final _userRepository = new UserRepository();

  ProfileTabBloc(BuildContext context);

  @override
  ProfileTabState get initialState => ProfileTabState(
        error: '',
        enableEditing: false,
        imagePath: null,
        profileSaved: false,
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
      case EnableEditModeEvent:
        final enable = (event as EnableEditModeEvent).enable;
        yield state.clone(enableEditing: enable);
        break;
      case SaveProfileEvent:
        final user = (event as SaveProfileEvent).user;
        final image = state.imagePath;
        if (image != null) {
          final String downloadURL =
              await _userRepository.uploadImageForUserProfilePic(image);
          user.profilePicture = downloadURL;
        }
        await _userRepository.update(item: user, type: DBUtil.USER);
        add(EnableEditModeEvent(false));
        yield state.clone(profileSaved: true);
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
