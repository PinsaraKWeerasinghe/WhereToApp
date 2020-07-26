import 'package:flutter/material.dart';
import 'package:whereto/db/model/Post.dart';
import 'package:whereto/db/model/Story.dart';

@immutable
class HomeTabState {
  final String error;
  final List<Story> stories;
  final List<Post> posts;

  HomeTabState({
    @required this.error,
    @required this.stories,
    @required this.posts,
  });

  HomeTabState clone({
    String error,
    List<Story> stories,
    List<Post> posts,
  }) {
    return HomeTabState(
      error: error ?? this.error,
      stories: stories ?? this.stories,
      posts: posts ?? this.posts,
    );
  }
}
