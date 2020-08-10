import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';

class User extends DBModel {
  String name;
  String username;
  String email;
  GeoPoint homeLocation;
  String status;
  String profilePicture;

  User({
    DocumentReference ref,
    this.name,
    this.username,
    this.email,
    this.homeLocation,
    this.status,
    this.profilePicture,
  }) : super(ref: ref);

  @override
  User clone() {
    return User(
      ref: ref,
      name: name,
      username: username,
      email: email,
      homeLocation: homeLocation,
      status: status,
      profilePicture: profilePicture,
    );
  }
}
