import 'package:built_value/built_value.dart';
import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user.g.dart';

@BuiltValue(instantiable: false)
abstract class User implements DBModelI {
  static const EMAIL_FIELD = "email";
  static const NAME_FIELD = "name";
  static const LAST_NAME_FIELD = "lastName";
  static const TYPE_FIELD = "type";

  String get email;
  String get name;
  String get lastName;

  @override
  String get id => ref.documentID;
}
