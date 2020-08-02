import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:whereto/theme/styled_colors.dart';
import 'package:whereto/views/root_page/root_page.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'newposttab_bloc.dart';
import 'newposttab_page.dart';
import 'newposttab_state.dart';

class NewPostTabView extends StatefulWidget {
  @override
  _NewPostTabViewState createState() => _NewPostTabViewState();
}

class _NewPostTabViewState extends State<NewPostTabView> {
  final log = Logger();
  TextEditingController _placeName = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  File _image;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() async {
      _image = File(pickedFile.path);
      print(pickedFile.path);
      final Directory systemTempDir = Directory.systemTemp;
      var storage = FirebaseStorage.instance;

      String imageName = pickedFile.path
          .substring(pickedFile.path.lastIndexOf("/"),
              pickedFile.path.lastIndexOf("."))
          .replaceAll("/", "");

      StorageTaskSnapshot snapshot = await storage
          .ref()
          .child("/Posts/Photos/$imageName")
          .putFile(_image)
          .onComplete;
      if (snapshot.error == null) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        await Firestore.instance
            .collection("Posts")
            .add({"photo_url": downloadUrl, "name": "superuser"});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final newposttabBloc = BlocProvider.of<NewPostTabBloc>(context);
    final rootBloc = BlocProvider.of<RootBloc>(context);
    log.d("Loading NewPostTab View");

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: Text(
          "Share a Place...",
          style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
        ),
      ),
      body: BlocBuilder<NewPostTabBloc, NewPostTabState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    child: TextField(
                      onTap: () {},
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                      controller: _placeName,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                        border: InputBorder.none,
                        labelText: "Place name",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: TextField(
                      onTap: () {},
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                      controller: _description,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                        border: InputBorder.none,
                        labelText: "Description",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(),
                      InkWell(
                          onTap: () {
                            newposttabBloc.add(TakeImageEvent());
                          },
                          child: Icon(Icons.camera_alt)),
                      InkWell(onTap: _getImage, child: Icon(Icons.photo)),
                      Container(),
                    ],
                  ),
                  (state.imagePath != null)
                      ? Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(File(state.imagePath)))),
                              child: Image.file(File(state.imagePath))),
                        )
                      : Expanded(child: Container()),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: StyledColors.PRIMARY_COLOR,
                      onPressed: () => newposttabBloc.add(
                        PostPublishEvent(
                          (_placeName.text ?? "").trim(),
                          (_description.text ?? "").trim(),
                          state.imagePath,
                          rootBloc.state.user.username,
                        ),
                      ),
                      child: Text(
                        "Post",
                        style: TextStyle(
                          fontSize: 14,
                          color: StyledColors.BUTTON_TEXT_PRIMARY,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<NewPostTabBloc, NewPostTabState>(
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
