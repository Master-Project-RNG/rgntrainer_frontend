import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/MyRoutes.dart';
import 'package:rgntrainer_frontend/provider/authProvider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'adminViewScreen.dart';
import 'loginScreen.dart';
import 'unknownScreen.dart';
import 'userViewScreen.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
      ],
      child: MaterialApp.router(
        routeInformationParser: VxInformationParser(),
        routerDelegate: VxNavigator(routes: {
          "/": (_, __) => MaterialPage(child: LoginScreen()),
          MyRoutes.adminRoute: (_, __) =>
              MaterialPage(child: AdminViewScreen()),
          MyRoutes.userRoute: (_, __) => MaterialPage(child: UserViewScreen()),
        }),
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
