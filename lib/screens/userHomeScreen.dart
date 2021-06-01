import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/models/user_results_model.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/provider/user_results_provider.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'dart:html' as html;

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserCard();
  }
}

class UserCard extends StatefulWidget {
  const UserCard({
    Key? key,
  }) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  //TODO: Show loading icon in case of loading
  var _isLoading = false;
  List<UserResults> _fetchedUserResults = [];
  late User _currentUser = User.init();

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    _fetchUserResults();
  }

  //Fetch all Listings
  Future _fetchUserResults() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserResultsProvider>(context, listen: false)
        .getUserResults(_currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    html.window.onBeforeUnload.listen((event) async {
      // do something
      _currentUser = UserSimplePreferences.getUser();
    });

    if (_currentUser.token == null || _currentUser.usertype != "user") {
      AuthProvider().logout(_currentUser.token);
      return NoTokenScreen();
    } else {
      final _myUserResultsProvider = context.watch<UserResultsProvider>();
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
          padding: EdgeInsets.all(100.0),
          child: Container(
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "User Ansicht",
                    style: TextStyle(fontSize: 42),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Resultate für User: ${_currentUser.username}",
                    style: TextStyle(fontSize: 34),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 5,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: userResultsData(_myUserResultsProvider),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget userResultsData(UserResultsProvider _myUserResultsProvider) {
    return DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text("Nummer"),
          ),
          DataColumn(
            label: Text("Abteilung"),
          ),
          DataColumn(
            label: Text("Datum"),
          ),
          DataColumn(
            label: Text("erreicht"),
          ),
          DataColumn(
            label: Text("Organisation gesagt"),
          ),
          DataColumn(
            label: Text("Abteilung gesagt"),
          ),
          DataColumn(
            label: Text("Büro gesagt"),
          ),
          DataColumn(
            label: Text("Vorname gesagt"),
          ),
          DataColumn(
            label: Text("Nachname gesagt"),
          ),
          DataColumn(
            label: Text("Begrüssung gesagt"),
          ),
          DataColumn(
            label: Text("Spezifische Wörter gesagt"),
          ),
          DataColumn(
            label: Text("Anrufbeantworter gestartet"),
          ),
          DataColumn(
            label: Text("Anrufbeantworter korrekt"),
          ),
          DataColumn(
            label: Text("Zurückgerufen (Falls AB)"),
          ),
          DataColumn(
            label: Text("Rückruf rechtzeitig (Falls AB)"),
          ),
          DataColumn(
            label: Text("Anruf abgeschlossen"),
          ),
        ],
        rows: _myUserResultsProvider.userResults
            .map((data) => DataRow(cells: [
                  DataCell(Text(data.number.toString())),
                  DataCell(Text(data.department.toString())),
                  DataCell(Text(data.date.toString())),
                  DataCell(getCheck(data.reached)),
                  DataCell(getCheck(data.saidOrganization)),
                  DataCell(getCheck(data.saidDepartment)),
                  DataCell(getCheck(data.saidBureau)),
                  DataCell(getCheck(data.saidFirstname)),
                  DataCell(getCheck(data.saidName)),
                  DataCell(getCheck(data.saidGreeting)),
                  DataCell(getCheck(data.saidSpecificWords)),
                  DataCell(getCheck(data.responderStarted)),
                  DataCell(getCheck(data.responderCorrect)),
                  DataCell(getCheck(data.callbackDone)),
                  DataCell(getCheck(data.callbackInTime)),
                  DataCell(getCheck(data.callCompleted)),
                ]))
            .toList());
  }
}

getCheck(bool? checked) {
  if (checked == null) {
    return Icon(Icons.minimize, color: Colors.grey, size: 24);
  }
  if (checked == true) {
    return Icon(Icons.check, color: Colors.green, size: 24);
  } else {
    return Icon(Icons.clear, color: Colors.red, size: 24);
  }
}
