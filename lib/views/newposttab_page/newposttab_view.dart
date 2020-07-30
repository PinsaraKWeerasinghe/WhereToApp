import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'newposttab_bloc.dart';
import 'newposttab_state.dart';

class NewPostTabView extends StatefulWidget {
  @override
  _NewPostTabViewState createState() => _NewPostTabViewState();
}

class _NewPostTabViewState extends State<NewPostTabView> {
  final log = Logger();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
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
            .add({"photo_url": downloadUrl,"name":"superuser"});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final newposttabBloc = BlocProvider.of<NewPostTabBloc>(context);
//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading NewPostTab View");

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      body: BlocBuilder<NewPostTabBloc, NewPostTabState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return Center(
              child: (1 == 1)
                  ? RaisedButton(
                      onPressed: getImage,
                    )
                  : Image.file(_image),
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
