import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'whereto_app_bloc.dart';
import 'whereto_app_view.dart';

class WhereToAppProvider extends BlocProvider<WhereToAppBloc> {
  WhereToAppProvider({
    Key key,
  }) : super(
          key: key,
          create: (context) => WhereToAppBloc(context),
          child: WhereToAppView(),
        );
}
