import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'searchtab_bloc.dart';
import 'searchtab_state.dart';

class SearchTabView extends StatelessWidget {
  final log = Logger();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final searchtabBloc = BlocProvider.of<SearchTabBloc>(context);
//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading SearchTab View");

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      body: BlocBuilder<SearchTabBloc, SearchTabState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return Center(
              child: Text("HI..."),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<SearchTabBloc, SearchTabState>(
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
