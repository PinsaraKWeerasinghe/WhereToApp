import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/theme/styled_colors.dart';
import 'package:whereto/views/hometab_page/hometab_bloc.dart';
import 'package:whereto/views/hometab_page/hometab_page.dart';
import 'package:whereto/views/newposttab_page/newposttab_bloc.dart';
import 'package:whereto/views/newposttab_page/newposttab_page.dart';
import 'package:whereto/views/profiletab_page/profiletab_page.dart';
import 'package:whereto/views/searchtab_page/searchtab_bloc.dart';
import 'package:whereto/views/searchtab_page/searchtab_view.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'home_bloc.dart';
import 'home_state.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin {
  final log = Logger();
  Widget _homeTab;
  Widget _searchTab;
  Widget _newPostTab;
  Widget _profileTab;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _homeTab = BlocProvider<HomeTabBloc>(
      create: (context) => HomeTabBloc(context),
      child: HomeTabView(),
    );
    _searchTab = BlocProvider<SearchTabBloc>(
      create: (context) => SearchTabBloc(context),
      child: SearchTabView(),
    );
    _newPostTab = BlocProvider<NewPostTabBloc>(
      create: (context) => NewPostTabBloc(context),
      child: NewPostTabView(),
    );
    _profileTab = BlocProvider<ProfileTabBloc>(
      create: (context) => ProfileTabBloc(context),
      child: ProfileTabView(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
  }

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading Home View");

    CustomSnackBar customSnackBar;

    final homeTab = Tab(child: Icon(Icons.home));
    final searchTab = Tab(child: Icon(Icons.search));
    final newPostTab = Tab(child: Icon(Icons.add));
    final profileTap = Tab(child: Icon(Icons.account_circle));

    final tabs = <Tab>[homeTab, searchTab, newPostTab, profileTap];

    final tabBar = TabBar(
      controller: _tabController,
      tabs: tabs,
    );

    final children = [_homeTab, _searchTab, _newPostTab, _profileTab];

    final scaffold = Scaffold(
      bottomNavigationBar: Material(
        color: StyledColors.PRIMARY_COLOR,
        shape: Border(
          top: BorderSide(
            width: 1,
            color: StyledColors.DIALOG_BACKGROUND_SEPARATOR,
          ),
        ),
        child: SafeArea(
          child: tabBar,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: children,
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
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
}
