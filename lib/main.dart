import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/MyRoutes.dart';
import 'package:rgntrainer_frontend/provider/authProvider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'adminViewScreen.dart';
import 'loginScreen.dart';
import 'userViewScreen.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter/services.dart';

import 'dart:io';

/*Future<bool> addSelfSignedCertificate() async {
  ByteData data = await rootBundle.load('assets/keystore.crt.pem');
  SecurityContext context = SecurityContext.defaultContext;
  context.setTrustedCertificatesBytes(data.buffer.asUint8List(),
      password: 'DXu534heb1U4XL');
  return true;
}*/

void main() {
//  addSelfSignedCertificate();
  HttpOverrides.global = new MyHttpOverrides();
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
        title: 'Begrüssungs- und Erreichbarkeitstrainer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
