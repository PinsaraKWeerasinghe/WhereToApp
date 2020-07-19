import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profiletab_bloc.dart';
import 'profiletab_view.dart';

class ProfileTabProvider extends BlocProvider<ProfileTabBloc> {
  ProfileTabProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => ProfileTabBloc(context),
          child: ProfileTabView(),
        );
}
