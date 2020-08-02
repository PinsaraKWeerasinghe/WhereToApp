import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_bloc.dart';
import 'register_view.dart';

class RegisterProvider extends BlocProvider<RegisterBloc> {
  RegisterProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => RegisterBloc(context),
          child: RegisterView(),
        );
}
