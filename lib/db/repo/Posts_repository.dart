import 'package:cloud_firestore/cloud_firestore.dart';
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
    post.user = data["user"];
    post.name = data["name"];
    post.photo = data["photo_url"];
    return post;
  }

  Future<Post> getStory(String documentID) async {
    return fromSnapshot(await Firestore.instance
        .collection(DBUtil.POSTS)
        .document(documentID)
        .get());
  }

  Stream<QuerySnapshot> getStoriesStream(){
    return Firestore.instance
        .collection(DBUtil.POSTS)
        .snapshots();
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
}
