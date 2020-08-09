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
    FocusNode _focusNodeText;
    final _textEditingController = TextEditingController();

    final scaffold = Scaffold(
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: Text(
          "Find Your Place or Person...",
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
      ),
      body: BlocBuilder<SearchTabBloc, SearchTabState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  height: 60,
                  padding: EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: <Widget>[
                        // Button send image
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          padding: EdgeInsets.only(left: 15),
                          child: TextField(
                            focusNode: _focusNodeText,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15.0),
                            maxLines: 1,
                            controller: _textEditingController,
//                            onChanged: (text) {
//                              if (_focusNodeText.hasFocus) {
//                                searchSubject
//                                    .add(text?.trim()?.toLowerCase());
//                              } else {
//                                searchSubject.add(null);
//                              }
//                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        // Button send message
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue,
                                child: new InkWell(
                                  child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: new Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      )),
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
