import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'newposttab_bloc.dart';
import 'newposttab_view.dart';

class NewPostTabProvider extends BlocProvider<NewPostTabBloc> {
  NewPostTabProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => NewPostTabBloc(context),
          child: NewPostTabView(),
        );
}
