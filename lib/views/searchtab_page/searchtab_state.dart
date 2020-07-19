import 'package:flutter/material.dart';

@immutable
class SearchTabState {
  final String error;

  SearchTabState({
    @required this.error,
  });

  SearchTabState clone({
    String error,
  }) {
    return SearchTabState(
      error: error ?? this.error,
    );
  }
}
