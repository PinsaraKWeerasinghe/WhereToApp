import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:whereto/db/model/user.dart';
import 'package:whereto/util/db_util.dart';

class UserRepository extends FirebaseRepository<User> {
  final _fireBaseInstance = Firestore.instance.collection("Users");

  void registerUsers(String name, String username, String email) {
    _fireBaseInstance.add({
      "name": name,
      "username": username,
      "email": email,
    });
  }

  @override
  User fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;
    final data = snapshot.data;
    if (data == null) return null;
    User user = User();
    user.name = data['name'] ?? "";
    user.email = data['email'];
    user.username = data['username'];
    user.about = data['about'];
    user.profilePicture = data['profile_picture'];
    return user;
  }

  @override
  Map<String, dynamic> toMap(User user) {
    final Map<String, dynamic> data = {
      "email": user.email,
      "name": user.name,
      "username": user.username,
      "about":user.about,
    };
    return data;
  }

  @override
  Stream<List<User>> query(
      {@required SpecificationI specification,
      String type,
      DocumentReference parent}) {
    return super.query(specification: specification, type: DBUtil.USER);
  }

  @override
  Future<List<User>> querySingle(
      {@required SpecificationI specification,
      String type,
      DocumentReference parent}) {
    return super.querySingle(specification: specification, type: DBUtil.USER);
  }
}
