import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fcode_bloc/fcode_bloc.dart';

class User extends DBModel {
  String name;
  String email;
  String tp;
  String address;
  String district;
  DocumentReference urbanCouncil;
  GeoPoint homeLocation;
  String fcmToken;

  User({
    DocumentReference ref,
    this.name,
    this.email,
    this.tp,
    this.address,
    this.district,
    this.urbanCouncil,
    this.homeLocation,
    this.fcmToken,
  }) : super(ref: ref);

  @override
  User clone() {
    return User(
      ref: ref,
      name: name,
      email: email,
      tp: tp,
      address: address,
      district: district,
      urbanCouncil: urbanCouncil,
      homeLocation: homeLocation,
      fcmToken: fcmToken,
    );
  }
}
