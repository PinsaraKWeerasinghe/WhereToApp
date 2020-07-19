import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hometab_bloc.dart';
import 'hometab_view.dart';

class HomeTabProvider extends BlocProvider<HomeTabBloc> {
  HomeTabProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => HomeTabBloc(context),
          child: HomeTabView(),
        );
}
