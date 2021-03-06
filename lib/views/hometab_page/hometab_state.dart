import 'package:flutter/material.dart';
import 'package:whereto/db/model/Post.dart';
import 'package:whereto/db/model/Story.dart';

@immutable
class HomeTabState {
  final String error;
  final List<Post> posts;
  final List<Story> stories;

  HomeTabState({
    @required this.error,
    @required this.stories,
    @required this.posts,
  });

  HomeTabState clone({
    String error,
    List<Story> stories,
    String storyImagePath,
    List<Post> posts,
  }) {
    return HomeTabState(
      error: error ?? this.error,
      stories: stories ?? this.stories,
      posts: posts ?? this.posts,
    );
  }
}
