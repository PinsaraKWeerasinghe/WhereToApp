import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/views/home_page/home_page.dart';
import 'package:whereto/views/login_page/login_event.dart';
import 'package:whereto/views/whereto_app_bloc.dart';
import 'package:whereto/views/whereto_app_event.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';
import 'package:whereto/util/assets.dart';
import 'package:whereto/theme/styled_colors.dart';

import 'login_bloc.dart';
import 'login_state.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  final log = Logger();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CustomSnackBar _customSnackBar;
  LoginBloc _loginBloc;
  WhereToAppBloc _appBloc;

  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _appBloc=BlocProvider.of<WhereToAppBloc>(context);
//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading Login View");

    _customSnackBar = CustomSnackBar(scaffoldKey: scaffoldKey);
    final scaffold = Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 128,
                        child: Image.asset(Assets.LOGO_GRAPHIC),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: 90,
                        child: TextField(
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            labelText:
                            "Email",
                            labelStyle: TextStyle(
                              fontSize: 20,
                            ),
                            helperText:
                            '10 Digit Number. Ex:0773683072',
                            helperStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 80,
                        child: TextField(
                          onTap: () {},
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),
//                          obscureText: _loginFormBloc.state.showPassword,
                          keyboardType: TextInputType.text,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                            border: InputBorder.none,
                            labelText:
                            "Password",
                            labelStyle: TextStyle(
                              fontSize: 20,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _onTogglePassword,
                              child: Icon(
//                                _loginFormBloc.state.showPassword
                              true
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: StyledColors.PRIMARY_COLOR,
                          onPressed: _onLoginPressed,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              color: StyledColors.BUTTON_TEXT_PRIMARY,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: _onRegisterPressed,
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              color: StyledColors.PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          condition: (pre, current) => pre.error != current.error,
          listener: (context, state) {
            if (state.error?.isNotEmpty ?? false) {
              _customSnackBar?.showErrorSnackBar(state.error);
            } else {
              _customSnackBar?.hideAll();
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
            condition: (pre, current) =>
            pre.email != current.email && current.email.isNotEmpty,
            listener: (context, state) {
              _customSnackBar.hideAll();
              _appBloc.add(UserLoggedEvent(state.email));
              log.d("Login successful.. navigating...");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeProvider(),
                ),
              );
            }),
      ],
      child: scaffold,
    );
  }

  _onLoginPressed() {
    _customSnackBar.showLoadingSnackBar();
    final phone = (_emailController.text ?? "").trim();
    final password = (_passwordController.text ?? "").trim();
    if (phone.isEmpty || password.isEmpty) {
      _customSnackBar.showErrorSnackBar("Phone number or Password is Empty!");
      return;
    }
    _loginBloc.add(UserLoginEvent(phone, password));
  }

  _onRegisterPressed() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => RegisterFormProvider(),
//      ),
//    );
  }

  _onTogglePassword() {
//    _loginFormBloc
//        .add(ToggleShowPasswordEvent(!_loginFormBloc.state.showPassword));
  }

}
