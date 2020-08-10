import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/model/user.dart';
import 'package:whereto/theme/styled_colors.dart';
import 'package:whereto/util/assets.dart';
import 'package:whereto/views/profiletab_page/profiletab_event.dart';
import 'package:whereto/views/root_page/root_page.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'profiletab_bloc.dart';
import 'profiletab_state.dart';

class ProfileTabView extends StatelessWidget {
  final log = Logger();

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  TextEditingController _usernameEditingController = TextEditingController();
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _statusEditingController = TextEditingController();
  ProfileTabBloc profiletabBloc;
  RootBloc rootBloc;

  @override
  Widget build(BuildContext context) {
    profiletabBloc = BlocProvider.of<ProfileTabBloc>(context);
    rootBloc = BlocProvider.of<RootBloc>(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    _usernameEditingController.text = rootBloc.state.user.username;
    _nameEditingController.text = rootBloc.state.user.name;
    _statusEditingController.text = rootBloc.state.user.status;

    log.d("Loading ProfileTab View");

    CustomSnackBar _customSnackBar = CustomSnackBar(scaffoldKey: scaffoldKey);
    final scaffold = Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xfff6f6f6),
        title: BlocBuilder<ProfileTabBloc, ProfileTabState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  rootBloc.state.user.username,
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.black),
                ),
                (!profiletabBloc.state.enableEditing)
                    ? InkWell(
                        onTap: () {
                          profiletabBloc.add(EnableEditModeEvent(true));
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(color: StyledColors.PRIMARY_COLOR),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          _customSnackBar.showLoadingSnackBar();
                          User user = rootBloc.state.user.clone();
                          user.username =
                              (_usernameEditingController.text).trim();
                          user.name = (_nameEditingController.text).trim();
                          user.status = (_statusEditingController.text).trim();
                          profiletabBloc.add(SaveProfileEvent(user));
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: StyledColors.PRIMARY_COLOR),
                        ),
                      )
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<ProfileTabBloc, ProfileTabState>(
        condition: (pre, current) => true,
        builder: (context, state) {
          return (!state.enableEditing)
              ? Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  (rootBloc.state.user.profilePicture != null)
                                      ? NetworkImage(
                                          rootBloc.state.user.profilePicture)
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
                          rootBloc.state.user.name,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontSize: 20),
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
                            rootBloc.state.user.status ?? "Hi! There...",
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
                )
              : _editPage();
        },
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileTabBloc, ProfileTabState>(
          condition: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false) {
              _customSnackBar?.showErrorSnackBar(state.error);
            } else {
              _customSnackBar?.hideAll();
            }
          },
        ),
        BlocListener<ProfileTabBloc, ProfileTabState>(
            condition: (pre, current) => current.profileSaved,
            listener: (context, state) {
              _customSnackBar.hideAll();
            }),
      ],
      child: scaffold,
    );
  }

  Widget _editPage() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (rootBloc.state.user.profilePicture != null)
                          ? NetworkImage(rootBloc.state.user.profilePicture)
                          : AssetImage(Assets.proPic),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white10,
                    shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 60,
            child: TextField(
              onTap: () {},
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
              controller: _usernameEditingController,
              obscureText: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                border: InputBorder.none,
                labelText: "Username",
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: TextField(
              onTap: () {},
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
              controller: _nameEditingController,
              obscureText: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                border: InputBorder.none,
                labelText: "Name",
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: TextField(
              onTap: () {},
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
              controller: _statusEditingController,
              obscureText: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                border: InputBorder.none,
                labelText: "Status",
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
