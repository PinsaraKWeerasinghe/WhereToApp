import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'searchtab_bloc.dart';
import 'searchtab_view.dart';

class SearchTabProvider extends BlocProvider<SearchTabBloc> {
  SearchTabProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => SearchTabBloc(context),
          child: SearchTabView(),
        );
}
