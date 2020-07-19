import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/util/assets.dart';
import 'package:whereto/views/home_page/home_page.dart';
import 'package:whereto/views/login_page/login_bloc.dart';
import 'package:whereto/views/login_page/login_page.dart';
import 'package:whereto/views/root_page/root_event.dart';
import 'package:whereto/views/whereto_app_bloc.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';
import 'package:whereto/db/authentication.dart';

import 'root_bloc.dart';
import 'root_state.dart';

class RootView extends StatelessWidget {
  final log = Logger();

  static final loadingWidget = Center(
    child: Image.asset(Assets.LOGO_GRAPHIC),
  );

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    log.d("Loading Root View");
    CustomSnackBar customSnackBar;
    return Scaffold(
      body: BlocBuilder<RootBloc, RootState>(
          condition: (pre, current) =>
              pre.page != current.page || pre.user != current.user,
          builder: (context, state) {
            if (state.page == RootState.LOGIN_PAGE) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<LoginBloc>(
                    create: (BuildContext context) => LoginBloc(context),
                  ),
                  BlocProvider<WhereToAppBloc>(
                    create: (BuildContext context) => WhereToAppBloc(context),
                  ),
                ],
                child: LoginView(),
              );
            } else if (state.page == RootState.HOME_PAGE) {
              return BlocProvider(
                create: (context) => HomeBloc(context),
                child: HomeView(),
              );
            } else if (state.page == RootState.LOADING_PAGE) {
              getUserName(rootBloc);
            }
            return loadingWidget;
          }),
    );
  }

  Future<void> getUserName(RootBloc rootBloc) async {
    final phone = await Authentication().getLoggedUserTelephone();
    if (phone != null) {
      rootBloc.add(InitialUserEvent(phone));
    }else{
      rootBloc.add(LogInEvent());
    }
  }
}
