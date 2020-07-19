import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_bloc.dart';
import 'login_view.dart';

class LoginProvider extends BlocProvider<LoginBloc> {
  LoginProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => LoginBloc(context),
          child: LoginView(),
        );
}
