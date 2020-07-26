import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'whereto_app_bloc.dart';
import 'whereto_app_state.dart';

class WhereToAppView extends StatelessWidget {
  final log = Logger();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final whereto_appBloc = BlocProvider.of<WhereToAppBloc>(context);
    log.d("Loading WhereToApp View");

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      body: BlocBuilder<WhereToAppBloc, WhereToAppState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return Center(
              child: Text("HI..."),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<WhereToAppBloc, WhereToAppState>(
          condition: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false) {
              customSnackBar?.showErrorSnackBar(state.error);
            } else {
              customSnackBar?.hideAll();
            }
          },
        ),
      ],
      child: scaffold,
    );
  }
}
