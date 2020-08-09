import 'dart:io';

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
import 'package:whereto/theme/styled_colors.dart';
import 'package:whereto/util/assets.dart';
import 'package:whereto/views/hometab_page/hometab_event.dart';
import 'package:whereto/views/newstory_page/newstory_bloc.dart';
import 'package:whereto/views/newstory_page/newstory_page.dart';
import 'package:whereto/views/newstory_page/newstory_view.dart';
import 'package:whereto/views/root_page/root_bloc.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'hometab_bloc.dart';
import 'hometab_state.dart';

class HomeTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  final log = Logger();
  RootBloc _rootBloc;
  HomeTabBloc _hometabBloc;
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
    _hometabBloc = BlocProvider.of<HomeTabBloc>(context);
    _rootBloc = BlocProvider.of<RootBloc>(context);
    log.d("Loading HomeTab View");

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: Center(
          child: Image.asset(
            Assets.APP_NAME_GRAPHIC,
            width: MediaQuery.of(context).size.width - 200,
          ),
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
                List<Widget> cards = new List();

                cards.add(SafeArea(
                  top: true,
                  bottom: true,
                  child: new Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: new SizedBox(
                      width: 50,
                      child: new Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewStoryProvider(),
                                    ),
                                  );
                                },
                              )
                            ]),
                        decoration: new BoxDecoration(
                          image: DecorationImage(
                            image: (_rootBloc.state.user.profilePicture != null)
                                ? NetworkImage(
                                    _rootBloc.state.user.profilePicture)
                                : AssetImage(Assets.proPic),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
//                          boxShadow: [
//                            BoxShadow(
//                              color: Colors.grey[300],
//                              blurRadius: 10.0,
//                              spreadRadius: 6.0,
//                              offset: Offset(0, 3),
//                            )
//                          ],
                        ),
                      ),
                    ),
                  ),
                ));
                if (snapshot.hasData) {
                  List<Story> stories = new List();
                  stories = snapshot.data.documents
                      .map((doc) => _storiesRepository.fromSnapshot(doc))
                      .toList();
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
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.grey[300],
//                  blurRadius: 10.0,
//                  spreadRadius: 6.0,
//                  offset: Offset(0, 3),
//                )
//              ],
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
          stream: _postsRepository.getPostsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> posts = new List();
              posts = snapshot.data.documents
                  .map((doc) => _postsRepository.fromSnapshot(doc))
                  .toList();
              if (posts != null && posts.length != 0) {
                List<Widget> cards = new List();
                for (Post p in posts) {
                  cards.add(post(p));
                }
                return Column(
                  children: cards,
                );
              } else {
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
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  (_rootBloc.state.user.profilePicture != null)
                                      ? NetworkImage(
                                          _rootBloc.state.user.profilePicture)
                                      : AssetImage(Assets.proPic),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.white10,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.black, width: 2.0)),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(post.name),
                    ),
                  ],
                ),
              ),
              (post.description != null)
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 10, bottom: 10, top: 10, right: 10),
                      child: Text(
                        post.description,
                        maxLines: 4,
                      ),
                    )
                  : SizedBox(
                      height: 10,
                    ),
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
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        InkWell(
                          child: Icon(Icons.highlight),
                        ),
                        Text("Like"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          child: Icon(Icons.comment),
                        ),
                        Text("Comment"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          child: Icon(Icons.screen_share),
                        ),
                        Text("Share"),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
