import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';

class Post extends DBModel {
  String namename;
  DocumentReference user;
  String photo;
  String docId;

  Post({
    DocumentReference ref,
    this.namename,
    this.user,
    this.photo,
  }) : super(ref: ref);

  @override
  Post clone() {
    return Post(
      ref: ref,
      namename: namename,
      user: user,
      photo: photo,
    );
  }
}