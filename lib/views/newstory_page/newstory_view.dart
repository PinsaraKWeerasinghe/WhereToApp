import 'dart:io';

import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/theme/styled_colors.dart';
import 'package:whereto/views/newstory_page/newstory_event.dart';
import 'package:whereto/views/root_page/root_bloc.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'newstory_bloc.dart';
import 'newstory_state.dart';

class NewStoryView extends StatelessWidget {
  final log = Logger();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final _newstoryBloc = BlocProvider.of<NewStoryBloc>(context);
    final rootBloc = BlocProvider.of<RootBloc>(context);
    log.d("Loading NewStory View");

    TextEditingController _storyController = new TextEditingController();

    CustomSnackBar _customSnackBar = CustomSnackBar(scaffoldKey:scaffoldKey);
    final scaffold = Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: Text(
          "New Story",
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
      ),
      body: BlocBuilder<NewStoryBloc, NewStoryState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  (_newstoryBloc.state.storyImagePath == null)
                      ? Material(
                          color: Colors.transparent,
                          child: TextField(
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            autofocus: true,
                            controller: _storyController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                              hintText: "Add the place to share...",
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                    File(_newstoryBloc.state.storyImagePath)),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 10.0,
                                  spreadRadius: 6.0,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Icon(Icons.camera_alt),
                            onTap: () {
                              _newstoryBloc.add(TakeStoryImageEvent());
                            },
                          ),
                          InkWell(
                            child: Icon(Icons.photo),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: StyledColors.PRIMARY_COLOR,
                          onPressed: () {
                            _customSnackBar.showLoadingSnackBar();
                            _newstoryBloc.add(StoryPublishEvent(
                              state.storyImagePath,
                              rootBloc.state.user.username,
                            ));
                          },
                          child: Text(
                            "Add Story",
                            style: TextStyle(
                              fontSize: 15,
                              color: StyledColors.BUTTON_TEXT_PRIMARY,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<NewStoryBloc, NewStoryState>(
          condition: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false) {
              _customSnackBar?.showErrorSnackBar(state.error);
            } else {
              _customSnackBar?.hideAll();
            }
          },
        ),
        BlocListener<NewStoryBloc, NewStoryState>(
            condition: (pre, current) => current.successfulPublish,
            listener: (context, state) {
              _customSnackBar.hideAll();
              log.d("Story Added Successfully...");
              Navigator.pop(context);
            }),
      ],
      child: scaffold,
    );
  }
}
