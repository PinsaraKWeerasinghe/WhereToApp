import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/model/Post.dart';
import 'package:whereto/db/model/Story.dart';
import 'package:whereto/db/repo/Stories_repository.dart';
import 'package:whereto/util/assets.dart';

import 'hometab_event.dart';
import 'hometab_state.dart';

class HomeTabBloc extends Bloc<HomeTabEvent, HomeTabState> {
  static final log = Logger();
  final StoriesRepository _storiesRepository = new StoriesRepository();

  HomeTabBloc(BuildContext context);

  @override
  HomeTabState get initialState => HomeTabState(
        error: '',
        stories: new List(),
        posts: new List(),
      );

  @override
  Stream<HomeTabState> mapEventToState(HomeTabEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case LoadStoriesEvent:
        List<Story> s = loadStories();
        yield state.clone(stories: s);
        break;
      case LoadPostsEvent:
        List<Post> p = loadPosts();
        yield state.clone(posts: p);
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

  List<Story> loadStories()  {
    Stream<QuerySnapshot> storiess= _storiesRepository.getStoriesStream();
    List<Story> stories = new List();
    stories.add(Story(name: "Jsmith", photo: Assets.s1));
    stories.add(Story(name: "Jsmith", photo: Assets.s2));
    stories.add(Story(name: "Michel", photo: Assets.s3));
    stories.add(Story(name: "Fernandez", photo: Assets.s4));
    stories.add(Story(name: "Jorge", photo: Assets.s5));
    stories.add(Story(name: "Stiwan", photo: Assets.s6));
    stories.add(Story(name: "Calton", photo: Assets.s7));
    stories.add(Story(name: "Kaushal", photo: Assets.s8));
    stories.add(Story(name: "Kaushal", photo: Assets.s9));
    stories.add(Story(name: "Kaushal", photo: Assets.s10));
    return stories;
  }

  List<Post> loadPosts() {
    List<Post> posts = new List();
    posts.add(Post(name: "Jsmith", photo: Assets.s1));
    posts.add(Post(name: "Jsmith", photo: Assets.s2));
    posts.add(Post(name: "Michel", photo: Assets.s3));
    posts.add(Post(name: "Fernandez", photo: Assets.s4));
    posts.add(Post(name: "Jorge", photo: Assets.s5));
    posts.add(Post(name: "Stiwan", photo: Assets.s6));
    posts.add(Post(name: "Calton", photo: Assets.s7));
    posts.add(Post(name: "Kaushal", photo: Assets.s8));
    posts.add(Post(name: "Kaushal", photo: Assets.s9));
    posts.add(Post(name: "Kaushal", photo: Assets.s10));
    return posts;
  }
}
