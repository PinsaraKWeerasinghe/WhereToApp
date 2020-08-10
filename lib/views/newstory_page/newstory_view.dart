import 'dart:io';

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
  final TextEditingController _cityEditingController =
      new TextEditingController();
  final TextEditingController _storyController = new TextEditingController();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final _newstoryBloc = BlocProvider.of<NewStoryBloc>(context);
    final rootBloc = BlocProvider.of<RootBloc>(context);
    log.d("Loading NewStory View");

    CustomSnackBar _customSnackBar = CustomSnackBar(scaffoldKey: scaffoldKey);
    final scaffold = Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
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
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                      child: TextField(
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                        controller: _cityEditingController,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: StyledColors.PRIMARY_COLOR, width: 5.0),
                          ),
                          labelText: "City",
                          labelStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        controller: _storyController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: StyledColors.PRIMARY_COLOR, width: 5.0),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          hintText: "What's on your mind about the place?",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                (_newstoryBloc.state.storyImagePath == null)
                    ? Container()
                    : Expanded(
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          Text("Open Camera")
                        ],
                      ),
                      onTap: () {
                        _newstoryBloc.add(TakeStoryImageEvent(true));
                      },
                    ),
                    Divider(),
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.photo),
                          Text("Gallery")
                        ],
                      ),
                      onTap: () {
                        _newstoryBloc.add(TakeStoryImageEvent(false));
                      },
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: StyledColors.PRIMARY_COLOR,
                        onPressed: () {
                          _customSnackBar.showLoadingSnackBar();
                          if (state.storyImagePath != null ||
                              _storyController.text.trim() != "") {
                            if (_cityEditingController.text.trim() != "") {
                              _newstoryBloc.add(StoryPublishEvent(
                                state.storyImagePath,
                                _storyController.text.trim(),
                                rootBloc.state.user.username,
                                _cityEditingController.text.trim(),
                              ));
                            } else {
                              _customSnackBar
                                  .showErrorSnackBar("City Can not be empty!");
                            }
                          } else {
                            _customSnackBar
                                .showErrorSnackBar("Story Can not be empty!");
                          }
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
        },
      ),
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
