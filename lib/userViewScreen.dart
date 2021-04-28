import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/provider/userResults.dart';

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
    Key key,
  }) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Future<void> _getData() async {
    try {
      await Provider.of<UserResultsProvider>(context, listen: false)
          .getUserResults('test');
    } catch (error) {
      const errorMessage = 'Could not find user. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
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
    _getData();
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
              "Resultate für User: +4176184147",
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
          testEntry(),
          testEntry2(),
          testEntry(),
        ],
      ),
    );
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

Widget testEntry() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "+41765184147",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "07/04/2021 21:31:45",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        width: 160,
        child: Icon(Icons.check, color: Colors.green, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.check, color: Colors.green, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.check, color: Colors.green, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.check, color: Colors.green, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.check, color: Colors.green, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.clear, color: Colors.red, size: 24),
      ),
    ],
  );
}

Widget testEntry2() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "+41765184147",
          style: TextStyle(fontSize: 20),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 160,
        child: Text(
          "07/04/2021 21:31:45",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      Container(
        width: 160,
        child: Icon(Icons.check, color: Colors.green, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.check, color: Colors.green, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.clear, color: Colors.red, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.check, color: Colors.green, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.clear, color: Colors.red, size: 24),
      ),
      Container(
        width: 160,
        child: Icon(Icons.clear, color: Colors.red, size: 24),
      ),
    ],
  );
}
