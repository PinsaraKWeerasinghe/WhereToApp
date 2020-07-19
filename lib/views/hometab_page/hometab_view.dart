import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/authentication.dart';
import 'package:whereto/theme/styled_colors.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'hometab_bloc.dart';
import 'hometab_state.dart';

class HomeTabView extends StatelessWidget {
  final log = Logger();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final hometabBloc = BlocProvider.of<HomeTabBloc>(context);
//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading HomeTab View");

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Gistoncampus",
              style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
            ),
            IconButton(icon: Icon(Icons.camera_alt), onPressed: null)
          ],
        ),
      ),
      body: BlocBuilder<HomeTabBloc, HomeTabState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return Column(
              children: <Widget>[
                Flexible(flex: 1, child: stories()),
                Flexible(
                  flex: 5,
                  child: Container(
                    child: Center(
                      child: RaisedButton(
                        onPressed: () {
                          logout();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeTabBloc, HomeTabState>(
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

  Widget stories() {
    List<Widget> cards = List();
    cards.add(story());
    cards.add(story());
    cards.add(story());
    return Row(
      children: cards,
    );
  }

  Widget story() {
    return SafeArea(
      top: true,
      bottom: true,
      child: new Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: new SizedBox(
          width: 50,
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 10.0,
                  spreadRadius: 6.0,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: new Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newsFeeds() {}

  logout() {
    Authentication().logout();
  }

}
