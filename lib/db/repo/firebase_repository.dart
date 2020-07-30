import 'package:cloud_firestore/cloud_firestore.dart';

import 'repository.dart';

abstract class FirebaseRepositoryI<T> implements RepositoryI<T> {
  T fromSnapshot(DocumentSnapshot snapshot);
}
