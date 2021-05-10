import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/userResults.dart';

class UserViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Begrüssungs- und Erreichbarkeitstrainer"),
      ),
      body: Container(
        padding: EdgeInsets.all(100.0),
        child: Container(
          child: UserCard(),
        ),
      ),
    );
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

  @override
  void initState() {
    super.initState();
    _fetchedUserResults = getUserResults('test');
  }

  List<UserResults> getUserResults(name) {
    _isLoading = true;
    //TODO: Replace mock with api call
    String userResultString =
        '[{"number":"+41765184147","bureau":"Gemeinde Rothenburg","date":"07/04/2021 21:30:33","saidCity":false,"saidName":false,"saidGreeting":false,"reached":true,"callCompleted":true,"responderStarted":false},{"number":"+41765184147","bureau":"Gemeinde Rothenburg","date":"07/04/2021 21:31:45","saidCity":false,"saidName":false,"saidGreeting":true,"reached":true,"callCompleted":false,"responderStarted":false}]';
    /*var url = Uri.parse(
      'http://localhost:8080/getUserResults?number=%2B41765184147');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    var response2 = getUserResults.json;
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    print(jsonResponse);
  } else {
    throw Exception('Failed to load user');
  }*/
    List<UserResults> _result = [];
    final List<dynamic> _temp = json.decode(userResultString);
    _temp.forEach((test) {
      final Map<String, dynamic> _temp2 = test;
      final UserResults userResults = UserResults.fromJson(_temp2);
      _result.add(userResults);
    });
    _isLoading = false;
    return _result;
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
    return Container(
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
              "Resultate für User: ${_fetchedUserResults[0].number}",
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
            child: printUserResults(_fetchedUserResults),
          ),
          //testEntry2(),
        ],
      ),
    );
  }
}

printUserResults(List<UserResults> _fetchedUserResults) {
  return ListView.builder(
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return singleDataRowEntry(_fetchedUserResults[index]);
    },
    itemCount: _fetchedUserResults.length,
  );
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
