import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rgntrainer_frontend/MyRoutes.dart';
import 'package:rgntrainer_frontend/api/adminCalls.dart';
import 'package:rgntrainer_frontend/models/getOpeningHours.dart';
import 'package:rgntrainer_frontend/models/user.dart';
import 'package:rgntrainer_frontend/provider/authProvider.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:rgntrainer_frontend/screens/loginScreen.dart';
import 'package:rgntrainer_frontend/screens/noTokenScreen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/utils/validator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:characters/characters.dart';

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
  var adminCalls = AdminCalls();
  var statusText = "init";
  int clickCounter = 0;
  var tempInterval = 0;
  var _isLoading = true;
  late OpeningHoursSummary _openingHours = OpeningHoursSummary.init();
  late User _currentUser = User.init();
  late TextEditingController _controller;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _currentUser = UserSimplePreferences.getUser();
    asyncLoadingData();
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void asyncLoadingData() async {
    setState(() {
      _isLoading = true;
    });
    _openingHours = await adminCalls.getOpeningHours(_currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }

  final GlobalKey<FormState> _formKeyAdmin = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    if (_currentUser.token == "none" || _currentUser.usertype != "admin") {
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
                  SizedBox(
                    height: 50,
                  ),
                  trainerStartenWidget(deviceSize),
                  SizedBox(
                    height: 50,
                  ),
                  anrufZeitenKonfigurieren(deviceSize),
                ],
              ),
            ),
          ),
        ),
      );
    }
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

  Widget anrufZeitenKonfigurieren(deviceSize) {
    return DefaultTabController(
      length: 3,
      child: Container(
        height: 320,
        constraints: BoxConstraints(minHeight: 320, minWidth: 500),
        width: deviceSize.width * 0.5,
        child: Card(
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: AppBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  title: Text("Anrufzeit konfigurieren"),
                  centerTitle: true,
                  elevation: 8.0,
                  automaticallyImplyLeading: false,
                  /*leading: InkWell(
                    child: IconButton(
                      icon: Icon(Icons.house),
                      onPressed: () {
                        AuthProvider().logout(_currentUser.token);
                        context.vxNav.replace(
                          Uri.parse(MyRoutes.loginRoute),
                        );
                      },
                    ),
                  ),*/
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: "Kommune",
                      ),
                      Tab(
                        text: "Abteilung",
                      ),
                      Tab(
                        text: "Nummer",
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: TabBarView(
                    children: [
                      openingHours("Kommune"),
                      Text("Abteilung"),
                      Text("Nummer"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget openingHours(tabType) {
    /*if (tabType == "Kommune") {*/
    ///  }
    if (_isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Container(
        //color: Colors.red,

        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SingleRowCallConfig(
                  "Montag",
                  _openingHours.openingHours[0].morningOpen,
                  _openingHours.openingHours[0].morningClose,
                  _openingHours.openingHours[0].afternoonOpen,
                  _openingHours.openingHours[0].afternoonClose),
              SingleRowCallConfig(
                  "Dienstag",
                  _openingHours.openingHours[1].morningOpen,
                  _openingHours.openingHours[1].morningClose,
                  _openingHours.openingHours[1].afternoonOpen,
                  _openingHours.openingHours[1].afternoonClose),
              Row(
                children: [Text("Dienstag")],
              ),
              Row(),
              Row(),
              Row(),
              Text(tabType),
              ElevatedButton(
                child: Text('Speichern'),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      );
  }

  Widget SingleRowCallConfig(
      weekday, _morningOpen, _morningClose, _afternoonOpen, _afternoonClose) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 62,
          width: 80,
          child: Text(weekday),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: 62,
          width: 40,
          child: Text("von "),
        ),
        Container(
          alignment: Alignment.topCenter,
          height: 50,
          width: 60,
          child: TextFormField(
            decoration: InputDecoration(
                counter: Offstage(),
                hintText: _morningOpen.substring(0, 5),
                errorStyle: TextStyle()),
            maxLength: 5,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            cursorHeight: 20,
            validator: (value) {
              if (value != "") {
                return Validator.validateTime(value);
              }
            },
            onSaved: (value) {
              if (value != null) {
                _morningOpen = value;
              }
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 60,
          width: 40,
          child: Text("bis"),
        ),
        Container(
          height: 50,
          width: 60,
          child: TextFormField(
            decoration: InputDecoration(
              counter: Offstage(),
              hintText: _morningClose.substring(0, 5),
            ),
            maxLength: 5,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            cursorHeight: 20,
            validator: (value) {
              if (value != "") {
                return Validator.validateTime(value);
              }
            },
            onSaved: (value) {
              if (value != null) {
                _morningClose = value;
              }
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 40,
          width: 80,
          child: Text("und von"),
        ),
        Container(
          height: 40,
          width: 60,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: _afternoonOpen.substring(0, 5),
            ),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            cursorHeight: 20,
            validator: (value) {
              if (value != "") {
                return Validator.validateTime(value);
              }
            },
            onSaved: (value) {
              if (value != null) {
                _afternoonOpen = value;
              }
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 40,
          width: 40,
          child: Text("bis"),
        ),
        Container(
          height: 40,
          width: 60,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: _afternoonClose.substring(0, 5),
            ),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            cursorHeight: 20,
            validator: (value) {
              if (value != "") {
                return Validator.validateTime(value);
              }
            },
            controller: _controller,
            onSaved: (value) {
              if (value != null) {
                _afternoonClose = value;
              }
            },
          ),
        ),
      ],
    );
  }

  _submit() {
    if (!_formKey.currentState!.validate()) {
      // Invali
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
//TODO: LOGIC
    setState(() {
      _isLoading = false;
    });
  }

  Widget trainerStartenWidget(deviceSize) {
    return Container(
      height: 320,
      constraints: BoxConstraints(minHeight: 320, minWidth: 500),
      width: deviceSize.width * 0.5,
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
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
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
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10),
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
                    adminCalls.startTrainer(tempInterval, _currentUser.token);
                    setState(() {
                      getStatus(_currentUser.token);
                    });
                    print('Short Press!');
                  },
                ),
                getStatus(_currentUser.token),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red, onPrimary: Colors.white),
                  child: Text('Stop'),
                  onPressed: () {
                    adminCalls.stopTrainer(_currentUser.token);
                    setState(() {
                      getStatus(_currentUser.token);
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
                      adminCalls.getResults(_currentUser.token);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Opening Hours:',
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
                    child: Text('Execute'),
                    onPressed: () {
                      print('Short Press!');
                      adminCalls.getOpeningHours(_currentUser.token);
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
