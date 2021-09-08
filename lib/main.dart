import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/provider/admin_numbers_provider.dart';
import 'package:rgntrainer_frontend/screens/admin_diagram_screen.dart';
import 'package:rgntrainer_frontend/screens/admin_numbers_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:rgntrainer_frontend/provider/answering_machine_provider.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/provider/results_download_provider.dart';
import 'package:rgntrainer_frontend/provider/user_results_provider.dart';
import 'package:rgntrainer_frontend/screens/admin_bureau_results_screen.dart';
import 'package:rgntrainer_frontend/screens/admin_cockpit_screen.dart';
import 'package:rgntrainer_frontend/screens/admin_profile_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/screens/admin_configuration_screen.dart';
import 'package:rgntrainer_frontend/screens/user_home_screen.dart';
import 'package:rgntrainer_frontend/screens/login_screen.dart';

// main function
// ignore: avoid_void_async
void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print(
        '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  runApp(
    MyApp(),
  );
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
        ChangeNotifierProvider.value(
          value: NumbersProvider(),
        ),
      ],
      child: MaterialApp.router(
        routeInformationParser: VxInformationParser(),
        routerDelegate: VxNavigator(
          routes: {
            //LoginScreen, blank route - starting point!
            "/": (_, __) => MaterialPage(
                  child: LoginScreen(),
                ),
            MyRoutes.adminConfigRoute: (_, __) => MaterialPage(
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
            MyRoutes.adminDiagramRoute: (_, __) => MaterialPage(
                  child: DiagramScreen(),
                ),
            MyRoutes.adminNumbersRoute: (_, __) => MaterialPage(
                  child: AdminNumbersScreen(),
                ),
          },
        ),
        title: 'Begrüssungs- und Erreichbarkeitstrainer',
        // Setting the theme of the application
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(25, 177, 237, 1), //cyan
          accentColor: const Color.fromRGBO(237, 85, 25, 1), //orange
          buttonColor: const Color.fromRGBO(25, 177, 237, 1), //cyan
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromRGBO(25, 177, 237, 1), //cyan
              ),
            ),
          ),
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: Colors.white),
            headline1: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
