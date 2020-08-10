import 'dart:async';

import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whereto/db/model/user.dart';
import 'package:whereto/db/repo/user_repository.dart';
import 'package:whereto/theme/styled_colors.dart';
import 'package:whereto/util/assets.dart';
import 'package:whereto/views/searchtab_page/searchtab_event.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'searchtab_bloc.dart';
import 'searchtab_state.dart';

class SearchTabView extends StatefulWidget {
  @override
  _SearchTabViewState createState() => _SearchTabViewState();
}

class _SearchTabViewState extends State<SearchTabView> {
  final log = Logger();

  SearchTabBloc searchTabBloc;

  FocusNode _focusNodeText;
  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();

  final searchSubject = BehaviorSubject<String>();
  StreamSubscription previousSubscription;

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNodeText = FocusNode();
    _focusNodeText.addListener(() {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      if (_focusNodeText.hasFocus) {
        searchSubject.add(_textEditingController.text?.trim()?.toLowerCase());
      } else {
        searchSubject.add(null);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
    _focusNodeText?.dispose();
    _scrollController?.dispose();
    searchSubject.close();
    previousSubscription?.cancel();
    searchTabBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    searchTabBloc = BlocProvider.of<SearchTabBloc>(context);
//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading SearchTab View");

    CustomSnackBar customSnackBar;

    final scaffold = Scaffold(
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: BlocBuilder<SearchTabBloc, SearchTabState>(
            builder: (context, state) {
          return (!state.showProfile)
              ? Text(
                  "Find Your Place or Person...",
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(state.user.username),
                    InkWell(
                      onTap: () {
                        searchTabBloc.add(ShowProfileEvent(null, false));
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(color: StyledColors.PRIMARY_COLOR),
                      ),
                    )
                  ],
                );
        }),
      ),
      body: BlocBuilder<SearchTabBloc, SearchTabState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return (!state.showProfile)
                ? Column(
                    children: [
                      Container(
                        height: 60,
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: <Widget>[
                              // Button send image
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                padding: EdgeInsets.only(left: 15),
                                child: TextField(
                                  focusNode: _focusNodeText,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15.0,
                                  ),
                                  maxLines: 1,
                                  controller: _textEditingController,
                                  onChanged: (text) {
                                    if (_focusNodeText.hasFocus) {
                                      searchSubject
                                          .add(text?.trim()?.toLowerCase());
                                    } else {
                                      searchSubject.add(null);
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Search...',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),

                              // Button send message
                              Material(
                                child: new Container(
                                  margin:
                                      new EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.blue,
                                      child: new InkWell(
                                        child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: new Icon(
                                              Icons.search,
                                              color: Colors.white,
                                            )),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ),
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: new ListView(
                          controller: _scrollController,
                          children: searchResult(),
                        ),
                      ),
                    ],
                  )
                : _showOther(state.user);
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<SearchTabBloc, SearchTabState>(
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

  List<Widget> searchResult() {
    List<Widget> _resultSet = new List();
    _resultSet.add(
      Container(
        child: new Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
          child: SearchResultList(
            searchTabBloc: searchTabBloc,
            data: UserRepository().query(
                specification: ComplexSpecification([
              ComplexWhere(
                "name",
                isEqualTo: "xs",
              )
            ])),
            searchStream: searchSubject.stream,
          ),
        ),
      ),
    );

    return _resultSet;
  }

  Widget _showOther(User user) {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: (user.profilePicture != null)
                      ? NetworkImage(user.profilePicture)
                      : AssetImage(Assets.proPic),
                  fit: BoxFit.cover,
                ),
                color: Colors.white10,
                shape: BoxShape.circle),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              user.name,
              style: TextStyle(
                  fontFamily: 'Raleway', color: Colors.black, fontSize: 20),
            ),
          ],
        ),
//          Padding(padding: EdgeInsets.all(10)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                user.status ?? "Hi! There...",
                maxLines: 4,
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(10)),
        Expanded(
          child: Container(
            color: Colors.grey[300],
            child: Center(
              child: Text("No content available!"),
            ),
          ),
        )
      ],
    );
  }
}

class SearchResultList extends StatelessWidget {
  final SearchTabBloc searchTabBloc;
  final Stream<List<User>> data;
  final Stream<String> searchStream;

  SearchResultList({this.searchTabBloc, this.data, this.searchStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: data,
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<String>(
          stream: searchStream,
          builder: (context, snapshot2) {
            return new Column(
              children: _getCards(
                snapshot.data,
                snapshot2.data ?? "",
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _getCards(
    List<User> users,
    String searchStr,
  ) {
//    comments.sort((a, b) => b.uniqueID.compareTo(a.uniqueID));
    List<InkWell> widgets = new List();
    users.forEach((user) {
      if (searchStr.isEmpty ||
          user.username.toLowerCase().contains(searchStr)) {
        widgets.add(searchCard(user));
//        widgets.add(
//            new CommentCard(add, delete, isAddingCard, comment));
      }
    });
    if (widgets.length > 10) {
      return widgets.sublist(0, 10);
    } else {
      return widgets;
    }
  }

  Widget searchCard(User user) {
    return InkWell(
      onTap: () {
        searchTabBloc.add(ShowProfileEvent(user, true));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(
          width: double.infinity,
          height: 30,
          child: Text(user.username),
        ),
      ),
    );
  }
}
