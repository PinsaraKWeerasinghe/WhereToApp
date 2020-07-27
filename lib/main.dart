import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whereto/views/root_page/root_page.dart';

import 'widgets/SplashScreen.dart';

void main() {
  runApp(WhereTo());
}

class WhereTo extends StatelessWidget {
  static final materialApp = MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "WHERETO",
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routes: <String, WidgetBuilder>{
      '/Root': (BuildContext context) => RootView()
    },
    home: SplashScreen(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RootBloc(context),
      child: materialApp,
    );
  }
}
