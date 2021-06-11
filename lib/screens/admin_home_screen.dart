import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/widgets/call_time_config.dart';
import 'package:rgntrainer_frontend/widgets/greeting/greeting_main.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminCard();
  }
}

class AdminCard extends StatefulWidget {
  const AdminCard({
    Key? key,
  }) : super(key: key);

  @override
  _AdminCardState createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminCard> {
  var adminCalls = AdminCallsProvider();
  var statusText = "init";
  var tempInterval = 0;
  late User _currentUser = User.init();

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    if (_currentUser.token == null || _currentUser.usertype != "admin") {
      return NoTokenScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Begrüssungs- und Erreichbarkeitstrainer"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                AuthProvider().logout(_currentUser.token);
                context.vxNav.replace(
                  Uri.parse(MyRoutes.loginRoute),
                );
              },
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  trainerStartenWidget(deviceSize),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CallTimeConfiguration(deviceSize, _currentUser),
                      SizedBox(
                        width: 50,
                      ),
                      GreetingConfigurationWidget(deviceSize),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  // _status has to be connected to the class attribute _status in order that setState() works, can't be handed in as a function parameter ;)
  Widget getStatus(String token) {
    return FutureBuilder<bool>(
        future: adminCalls.getTrainerStatus(token),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            //TODO: TESTEN
            if (snapshot.data == true) {
              var statusText = 'Status: Eingeschaltet';
              return Text(statusText);
            } else {
              var statusText = 'Status: Ausgeschaltet';
              return Text(statusText);
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget trainerStartenWidget(deviceSize) {
    return Container(
      constraints: BoxConstraints(minHeight: 280, minWidth: 500),
      width: deviceSize.width * 0.825,
      child: Card(
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              child: AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                title: Text("Trainer starten"),
                centerTitle: true,
                elevation: 8.0,
                automaticallyImplyLeading: false,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Steuerung für den Trainer:',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green, onPrimary: Colors.white),
                  onPressed: () {
                    adminCalls.startTrainer(tempInterval, _currentUser.token);
                    setState(() {
                      getStatus(_currentUser.token!);
                    });
                    print('Short Press!');
                  },
                  child: const Text('Start'),
                ),
                getStatus(_currentUser.token!),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red, onPrimary: Colors.white),
                  onPressed: () {
                    adminCalls.stopTrainer(_currentUser.token);
                    setState(() {
                      getStatus(_currentUser.token!);
                    });
                    // ignore: avoid_print
                    print('Short Press!');
                  },
                  child: const Text('Stop'),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Pause zw. den Anrufen in Sekunden:',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  height: 50,
                  width: 200,
                  child: SpinBox(
                    min: 0,
                    max: 600,
                    value: 0,
                    onChanged: (value) {
                      tempInterval = value.toInt();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    'Resultate:',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue, onPrimary: Colors.white),
                    child: Text('Download'),
                    onPressed: () {
                      print('Short Press!');
                      adminCalls.getResults(_currentUser.token);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
