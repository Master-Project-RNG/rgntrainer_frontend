import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:rgntrainer_frontend/provider/answering_machine_provider.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/provider/results_download_provider.dart';
import 'package:rgntrainer_frontend/provider/user_results_provider.dart';
import 'package:rgntrainer_frontend/screens/admin_bureau_results_screen.dart';
import 'package:rgntrainer_frontend/screens/admin_cockpit_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
//My files
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/screens/admin_configuration_screen.dart';
import 'package:rgntrainer_frontend/screens/user_home_screen.dart';
import 'package:rgntrainer_frontend/screens/login_screen.dart';

import 'screens/admin_profile_screen.dart';

/*
Future<bool> addSelfSignedCertificate() async {
  ByteData data = await rootBundle.load('assets/keystore.crt.pem');
  SecurityContext context = SecurityContext.defaultContext;
  context.setTrustedCertificatesBytes(data.buffer.asUint8List(),
      password: 'DXu534heb1U4XL');
  return true;
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  addSelfSignedCertificate();
  // HttpOverrides.global = new MyHttpOverrides();
  //setPathUrlStrategy();
  await UserSimplePreferences.init();
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
        ChangeNotifierProvider.value(
          value: UserResultsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: BureauResultsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: DownloadResultsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AdminCallsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AnsweringMachineProvider(),
        ),
      ],
      child: MaterialApp.router(
        routeInformationParser: VxInformationParser(),
        routerDelegate: VxNavigator(routes: {
          "/": (_, __) => MaterialPage(
                child: LoginScreen(),
              ),
          MyRoutes.adminRoute: (_, __) => MaterialPage(
                child: AdminConfigurationScreen(),
              ),
          MyRoutes.userRoute: (_, __) => MaterialPage(
                child: UserHomeScreen(),
              ),
          MyRoutes.adminProfilRoute: (_, __) => MaterialPage(
                child: AdminProfileScreen(),
              ),
          MyRoutes.adminCockpitRoute: (_, __) => MaterialPage(
                child: CockpitScreen(),
              ),
          MyRoutes.adminResultsRoute: (_, __) => MaterialPage(
                child: AdminResultsScreen(),
              ),
        }),
        title: 'Begrüssungs- und Erreichbarkeitstrainer',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(25, 177, 237, 1), //cyan
          accentColor: Color.fromRGBO(237, 85, 25, 1), //orange
          buttonColor: Color.fromRGBO(25, 177, 237, 1), //cyan
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(25, 177, 237, 1), //cyan
              ),
            ),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
            headline1: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
/*
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/
