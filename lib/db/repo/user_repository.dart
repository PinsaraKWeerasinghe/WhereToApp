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
    return user;
//    final data = snapshot.data;
//    if (data == null) return null;
//    if (data[User.TYPE_FIELD] == (Client).toString()) {
//      return Client(
//        (b) => b
//          ..ref = snapshot.reference
//          ..email = data[User.EMAIL_FIELD]
//          ..name = data[User.NAME_FIELD]
//          ..lastName = data[User.LAST_NAME_FIELD]
//          ..code=data[Client.CODE]
//          ..note=data[Client.NOTE]
//          ..therapist = data[Client.THERAPIST],
//      );
//    } else if (data[User.TYPE_FIELD] == (Therapist).toString()) {
//      return Therapist(
//        (b) => b
//          ..ref = snapshot.reference
//          ..email = data[User.EMAIL_FIELD]
//          ..name = data[User.NAME_FIELD]
//          ..lastName = data[User.LAST_NAME_FIELD],
//      );
//      /*final therapist = serializers.deserializeWith(Therapist.serializer, data);
//      return (therapist.toBuilder()..ref = snapshot.reference).build();*/
//    }
  }

  @override
  Map<String, dynamic> toMap(User user) {
    final Map<String, dynamic> data = {
      "email": user.email,
      "name": user.name,
      "username": user.username,
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
