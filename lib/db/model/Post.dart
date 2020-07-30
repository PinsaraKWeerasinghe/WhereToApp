import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';

class Post extends DBModel {
  String name;
  DocumentReference user;
  String photo;
  String docId;

  Post({
    DocumentReference ref,
    this.name,
    this.user,
    this.photo,
  }) : super(ref: ref);

  @override
  Post clone() {
    return Post(
      ref: ref,
      name: name,
      user: user,
      photo: photo,
    );
  }
}