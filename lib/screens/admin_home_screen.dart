import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/widgets/call_time_config.dart';
import 'package:rgntrainer_frontend/widgets/greeting/greeting_main.dart';
import 'package:rgntrainer_frontend/widgets/trainer_config.dart';
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
  var statusText = "init";
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
              icon: Icon(Icons.list_alt),
              onPressed: () {
                context.vxNav.push(
                  Uri.parse(MyRoutes.adminResultsRoute),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.build_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                context.vxNav.push(
                  Uri.parse(MyRoutes.adminProfilRoute),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                AuthProvider().logout(_currentUser.token);
                context.vxNav.push(
                  Uri.parse(MyRoutes.loginRoute),
                );
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: (MediaQuery.of(context).size.width > 1500)
              ? normalWidth(deviceSize)
              : smallWidth(deviceSize),
        ),
      );
    }
  }

  Widget normalWidth(deviceSize) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: SingleChildScrollView(
          //scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TrainerConfiguration(deviceSize),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: GreetingConfigurationWidget(deviceSize, type: 1),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CallTimeConfiguration(deviceSize, _currentUser),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: GreetingConfigurationWidget(deviceSize, type: 2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget smallWidth(deviceSize) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: SingleChildScrollView(
          //scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TrainerConfiguration(deviceSize),
              SizedBox(
                height: 50,
              ),
              GreetingConfigurationWidget(deviceSize, type: 1),
              SizedBox(
                height: 50,
              ),
              CallTimeConfiguration(deviceSize, _currentUser),
              SizedBox(
                height: 50,
              ),
              GreetingConfigurationWidget(deviceSize, type: 2),
            ],
          ),
        ),
      ),
    );
  }
}
