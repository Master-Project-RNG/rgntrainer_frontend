import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/MyRoutes.dart';
import 'package:rgntrainer_frontend/models/user.dart';
import 'package:rgntrainer_frontend/models/userResults.dart';
import 'package:rgntrainer_frontend/provider/authProvider.dart';
import 'package:rgntrainer_frontend/screens/noTokenScreen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/widgets/errorDialog.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

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
  late User _currentUser = User(
      username: "none",
      organization: "none",
      token: "none",
      usertype: "none",
      openingHours: [],
      greetingConfiguration: "none");

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
  }

  Future<List<UserResults>> getUserResults(token) async {
    _isLoading = true;
    var url = Uri.parse('http://188.155.65.59:8081/getUserResults');
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        'token': token,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      debugPrint(jsonResponse.toString());
      List<UserResults> _result = [];
      final List<dynamic> _temp = jsonResponse;
      _temp.forEach((test) {
        final Map<String, dynamic> _temp2 = test;
        final UserResults userResults = UserResults.fromJson(_temp2);
        _result.add(userResults);
      });
      _isLoading = false;
      return _result;
    } else {
      throw Exception('Failed to load user');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error occured!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay!'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser.token == "none" || _currentUser.usertype != "user") {
      AuthProvider().logout(_currentUser.token);
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
          padding: EdgeInsets.all(100.0),
          child: Container(
            child: Container(
              child: Column(
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
                    height: 3,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  testHeader(),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 3,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: printUserResults(_currentUser.token),
                  ),
                  //testEntry2(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget printUserResults(token) {
    return FutureBuilder<List<UserResults>>(
        future: getUserResults(token),
        builder: (context, AsyncSnapshot<List<UserResults>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            _fetchedUserResults = snapshot.data!;
            //TODO: TESTEN
            return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return singleDataRowEntry(_fetchedUserResults[index]);
              },
              itemCount: _fetchedUserResults.length,
            );
          } else
            return Container();
        });
  }
}

Widget testHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "Nummer",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "Datum",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "erreicht",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "Stadt gesagt",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "Name gesagt",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "Begrüssung gesagt",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "Anruf abgeschlossen",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "Anrufbeantworter",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
    ],
  );
}

Widget singleDataRowEntry(UserResults _fetchedUserResults) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          _fetchedUserResults.number!,
          //futureUserResults.number,
          style: TextStyle(fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          _fetchedUserResults.date!,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        width: 160,
        child: getCheck(_fetchedUserResults.reached == "true"),
      ),
      Container(
        width: 160,
        child: getCheck(_fetchedUserResults.saidCity == "true"),
      ),
      Container(
        width: 160,
        child: getCheck(_fetchedUserResults.saidName == "true"),
      ),
      Container(
        width: 160,
        child: getCheck(_fetchedUserResults.saidGreeting == "true"),
      ),
      Container(
        width: 160,
        child: getCheck(_fetchedUserResults.callCompleted == "true"),
      ),
      Container(
        width: 160,
        child: getCheck(_fetchedUserResults.responderStarted == "true"),
      ),
    ],
  );
}

getCheck(bool checked) {
  if (checked == true) {
    return Icon(Icons.check, color: Colors.green, size: 24);
  } else {
    return Icon(Icons.clear, color: Colors.red, size: 24);
  }
}
