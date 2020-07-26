import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'profiletab_bloc.dart';
import 'profiletab_state.dart';

class ProfileTabView extends StatelessWidget {
  final log = Logger();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final profiletabBloc = BlocProvider.of<ProfileTabBloc>(context);
//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading ProfileTab View");

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      body: BlocBuilder<ProfileTabBloc, ProfileTabState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return Center(
              child: Text("HI..."),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileTabBloc, ProfileTabState>(
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
