import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'newstory_bloc.dart';
import 'newstory_view.dart';

class NewStoryProvider extends BlocProvider<NewStoryBloc> {
  NewStoryProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => NewStoryBloc(context),
          child: NewStoryView(),
        );
}
