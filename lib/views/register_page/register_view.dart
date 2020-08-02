import 'package:fcode_bloc/fcode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:whereto/db/model/user.dart';
import 'package:whereto/theme/styled_colors.dart';
import 'package:whereto/util/assets.dart';
import 'package:whereto/views/register_page/register_page.dart';
import 'package:whereto/widgets/custom_snak_bar.dart';

import 'register_bloc.dart';
import 'register_state.dart';

class RegisterView extends StatelessWidget {
  final log = Logger();
  RegisterBloc _registerBloc;
  final _nameController = TextEditingController();
  final _uNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static final loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
//    final rootBloc = BlocProvider.of<RootPageBloc>(context);
    log.d("Loading Register View");

    CustomSnackBar customSnackBar;
    final scaffold = Scaffold(
      key: scaffoldKey,
      body: BlocBuilder<RegisterBloc, RegisterState>(
          condition: (pre, current) => true,
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 128,
                          child: Image.asset(Assets.ONLY_LOGO_GRAPHIC),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Create a new account",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextField(
                            onTap: () {},
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                            controller: _nameController,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
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
                            controller: _emailController,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                              border: InputBorder.none,
                              labelText: "Email",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            controller: _uNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              labelText: "Username",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                              helperText:
                                  "*Username Should be Unique for each users.",
                              helperStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
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
                            controller: _passwordController,
                            obscureText: !_registerBloc.state.showPassword,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                              border: InputBorder.none,
                              labelText: "Password",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: _onTogglePassword,
                                child: Icon(
                                  _registerBloc.state.showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: StyledColors.PRIMARY_COLOR,
                            onPressed: () {
                              _onRegisterPressed(context);
                            },
                            child: Text(
                              "Register",
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
                            color: StyledColors.primaryColor(0.1),
                            onPressed: () => _onLoginPressed(context),
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 16,
                                color: StyledColors.PRIMARY_COLOR,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
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

  void _onTogglePassword() {
    _registerBloc
        .add(ToggleShowPasswordEvent(!_registerBloc.state.showPassword));
  }

  void _onLoginPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _onRegisterPressed(BuildContext context) {
    _registerBloc.add(UserRegisterEvent(
      (_nameController.text ?? "").trim(),
      (_uNameController.text ?? "").trim(),
      (_passwordController.text ?? "").trim(),
      (_emailController.text ?? "").trim(),
    ));
  }
}
