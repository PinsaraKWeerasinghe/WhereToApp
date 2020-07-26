import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';

class Story extends DBModel {
  String name;
  DocumentReference user;
  String photo;

  Story({
    DocumentReference ref,
    this.name,
    this.user,
    this.photo,
  }) : super(ref: ref);

  @override
  Story clone() {
    return Story(
      ref: ref,
      name: name,
      user: user,
      photo: photo,
    );
  }
}
