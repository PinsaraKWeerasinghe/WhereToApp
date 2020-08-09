import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';

class   Story extends DBModel {
  String docId;
  String name;
  DocumentReference user;
  String photo;
  int type;

  Story({
    DocumentReference ref,
    this.name,
    this.user,
    this.photo,
    this.type,
  }) : super(ref: ref);

  @override
  Story clone() {
    return Story(ref: ref, name: name, user: user, photo: photo, type: type);
  }
}
