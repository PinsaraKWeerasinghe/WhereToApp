import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/util/assets.dart';
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
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: Text(
          "Profile",
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.proPic),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white10,
                  shape: BoxShape.circle),
            ),
          ),
          Text(
            "Steewan Smith",
            style: TextStyle(
                fontFamily: 'Raleway', color: Colors.black, fontSize: 20),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Text("Hi there! this is status."),
          Padding(padding: EdgeInsets.all(10)),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: Text("No content available!"),
              ),
            ),
          )
        ],
      ),
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
