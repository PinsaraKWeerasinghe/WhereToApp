import 'dart:async';

//import 'package:fcode_fit/db/specification/specification.dart';

abstract class RepositoryI<T> {
  Future<void> add(T item);

  Future<void> addList(Iterable<T> items);

//  Future<List<T>> query(SpecificationI specification);

  void remove(T item);

//  void removeList(SpecificationI specification);

  Future<void> update(T item);
}
