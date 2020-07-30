import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/authentication.dart';
import 'package:whereto/db/model/Post.dart';
import 'package:whereto/db/model/Story.dart';
import 'package:whereto/db/repo/Posts_repository.dart';
import 'package:whereto/db/repo/Stories_repository.dart';
import 'package:whereto/util/assets.dart';
import 'package:whereto/views/hometab_page/hometab_event.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'hometab_bloc.dart';
import 'hometab_state.dart';

class HomeTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  final log = Logger();
  final StoriesRepository _storiesRepository = new StoriesRepository();
  final PostsRepository _postsRepository = new PostsRepository();
  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hometabBloc = BlocProvider.of<HomeTabBloc>(context);

//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading HomeTab View");

//    hometabBloc.add(LoadStoriesEvent());
//    hometabBloc.add(LoadPostsEvent());

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              Assets.APP_NAME_GRAPHIC,
              width: MediaQuery.of(context).size.width - 200,
            ),
            IconButton(icon: Icon(Icons.camera_alt), onPressed: null)
          ],
        ),
      ),
      body: BlocBuilder<HomeTabBloc, HomeTabState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: stories(state.stories),
                ),
                Flexible(
                  flex: 5,
                  child: posts(state.posts),
                ),
              ],
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeTabBloc, HomeTabState>(
          condition: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false) {
              customSnackBar?.showErrorSnackBar(state.error);
            } else {
              customSnackBar?.hideAll();
            }
          },
        ),
      ],
      child: scaffold,
    );
  }

  Widget stories(List<Story> stories) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream: _storiesRepository.getStoriesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Story> stories = new List();
                  stories = snapshot.data.documents
                      .map((doc) => _storiesRepository.fromSnapshot(doc))
                      .toList();
                  List<Widget> cards = new List();
                  for (Story s in stories) {
                    cards.add(story(s));
                  }
                  return Row(
                    children: cards,
                  );
                } else {
                  return Center(child: Text("No Stories"));
                }
              }),
        ),
      ],
    );
  }

  Widget story(Story story) {
    return SafeArea(
      top: true,
      bottom: true,
      child: new Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: new SizedBox(
          width: 50,
          child: new Container(
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(story.photo),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 10.0,
                  spreadRadius: 6.0,
                  offset: Offset(0, 3),
                )
              ],
            ),
//            child: new Stack(
//              children: <Widget>[
//                GestureDetector(
//                  onTap: () {},
//                  child: Container(
//                      child:Image.asset(Assets.LOGO_GRAPHIC),
//                  ),
//                ),
//              ],
//            ),
          ),
        ),
      ),
    );
  }

  Widget posts(List<Post> posts) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: StreamBuilder<QuerySnapshot>(
          stream: _postsRepository.getStoriesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> posts = new List();
              posts = snapshot.data.documents
                  .map((doc) => _postsRepository.fromSnapshot(doc))
                  .toList();
              if(posts!=null && posts.length!=0){
                List<Widget> cards = new List();
                for (Post p in posts) {
                  cards.add(post(p));
                }
                return Column(
                  children: cards,
                );
              }else{
                return Center(child: Text("No Posts Here..."));
              }

            } else {
              return Center(child: Text("No Posts..."));
            }
          }),
    );
  }

  Widget post(Post post) {
    return SafeArea(
      top: true,
      bottom: true,
      child: new Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: new SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(post.name),
              Container(
                height: 300,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(post.photo),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 10.0,
                      spreadRadius: 6.0,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
//            child: new Stack(
//              children: <Widget>[
//                GestureDetector(
//                  onTap: () {},
//                  child: Container(
//                      child:Image.asset(Assets.LOGO_GRAPHIC),
//                  ),
//                ),
//              ],
//            ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logout() {
    Authentication().logout();
  }
}
