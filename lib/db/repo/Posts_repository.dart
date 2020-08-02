import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whereto/db/model/Post.dart';
import 'package:whereto/db/model/Story.dart';
import 'package:whereto/util/db_util.dart';

import 'firebase_repository.dart';

class PostsRepository implements FirebaseRepositoryI<Post> {
  static PostsRepository _postsRepository;

  factory PostsRepository() {
    if (_postsRepository == null) {
      _postsRepository = PostsRepository._internal();
    }
    return _postsRepository;
  }

  PostsRepository._internal();

  @override
  Post fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;
    final data = snapshot.data;
    if (data == null) return null;
    Post post = new Post();
    post.docId = snapshot.documentID;
    post.namename = data["username"];
    post.photo = data["photo_url"];
    return post;
  }

  Future<Post> getPost(String documentID) async {
    return fromSnapshot(await Firestore.instance
        .collection(DBUtil.POSTS)
        .document(documentID)
        .get());
  }

  Stream<QuerySnapshot> getPostsStream() {
    return Firestore.instance.collection(DBUtil.POSTS).snapshots();
  }

  Future<String> uploadImageForPost(String path) async {
    String imageName = path
        .substring(path.lastIndexOf("/"), path.lastIndexOf("."))
        .replaceAll("/", "");

    StorageTaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child("/Posts/Photos/$imageName")
        .putFile(File(path))
        .onComplete;
    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    } else {
      return null;
    }
  }

  @override
  Future<void> add(Post item) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> addList(Iterable<Post> items) {
    // TODO: implement addList
    throw UnimplementedError();
  }

  @override
  void remove(Post item) {
    // TODO: implement remove
  }

  @override
  Future<void> update(Post item) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<void> updatePostToDB(
      String placeName,
      String description,
      String downloadURL,
      String username,
      ) async {
    Firestore.instance.collection("Posts").add({
      "place_name":placeName,
      "description":description,
      "photo_url": downloadURL,
      "username": username,
    });
  }


}
