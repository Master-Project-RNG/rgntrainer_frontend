import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/api/adminCalls.dart';
import 'package:rgntrainer_frontend/models/user.dart';
import 'package:rgntrainer_frontend/provider/authProvider.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class AdminViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Begrüssungs- und Erreichbarkeitstrainer"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: AdminCard(),
            ),
          ),
        ),
      ),
    );
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
  var adminCalls = AdminCalls();
  var statusText = "init";
  int clickCounter = 0;
  late User currentUser;
  var tempInterval = 0;

  @override
  void initState() {
    currentUser =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser;
    super.initState();
  }

  final GlobalKey<FormState> _formKeyAdmin = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 300,
        constraints: BoxConstraints(minHeight: 300, minWidth: 500),
        width: deviceSize.width * 0.5,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyAdmin,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Text(
                'Admin Ansicht',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Steuerung für den Trainer:',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green, onPrimary: Colors.white),
                    child: Text('Start'),
                    onPressed: () {
                      adminCalls.startTrainer(tempInterval, currentUser.token);
                      setState(() {
                        getStatus(currentUser.token);
                      });
                      print('Short Press!');
                    },
                  ),
                  getStatus(currentUser.token),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red, onPrimary: Colors.white),
                    child: Text('Stop'),
                    onPressed: () {
                      adminCalls.stopTrainer(currentUser.token);
                      setState(() {
                        getStatus(currentUser.token);
                      });
                      print('Short Press!');
                    },
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        adminCalls.getResults(currentUser.token);
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // _status has to be connected to the class attribute _status in order that setState() works, can't be handed in as a function parameter ;)
  Widget getStatus(token) {
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
          } else
            return CircularProgressIndicator();
        });
  }
}
