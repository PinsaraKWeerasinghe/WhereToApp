import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whereto/db/model/Story.dart';
import 'package:whereto/util/db_util.dart';

import 'firebase_repository.dart';

class StoriesRepository implements FirebaseRepositoryI<Story> {
  static StoriesRepository _storiesRepository;

  factory StoriesRepository() {
    if (_storiesRepository == null) {
      _storiesRepository = StoriesRepository._internal();
    }
    return _storiesRepository;
  }

  StoriesRepository._internal();

  @override
  Story fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;
    final data = snapshot.data;
    if (data == null) return null;
    Story story = new Story();
    story.docId = snapshot.documentID;
    story.user = data["user"];
    story.photo = data["photo_url"];
    story.type = data["type"];
    return story;
  }

  Future<Story> getStory(String documentID) async {
    return fromSnapshot(await Firestore.instance
        .collection(DBUtil.STORIES)
        .document(documentID)
        .get());
  }

  Stream<QuerySnapshot> getStoriesStream() {
    return Firestore.instance.collection(DBUtil.STORIES).snapshots();
  }

  @override
  Future<void> add(Story item) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> addList(Iterable<Story> items) {
    // TODO: implement addList
    throw UnimplementedError();
  }

  @override
  void remove(Story item) {
    // TODO: implement remove
  }

  @override
  Future<void> update(Story item) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<String> uploadImageForStory(String path) async {
    String imageName = path
        .substring(path.lastIndexOf("/"), path.lastIndexOf("."))
        .replaceAll("/", "");

    StorageTaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child("/Stories/Photos/$imageName")
        .putFile(File(path))
        .onComplete;
    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    } else {
      return null;
    }
  }

  Future<void> updateStoryToDB(
      String downloadURL,
      String username,
      ) async {
    Firestore.instance.collection("Stories").add({
      "photo_url": downloadURL,
      "username": username,
    });
  }


}
