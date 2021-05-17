import 'dart:ui' as ui;

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

class _AdminCardState extends State<AdminCard>
    with
        SingleTickerProviderStateMixin /*SingleTickerProviderStateMixin used for TabController vsync*/ {
  var adminCalls = AdminCalls();
  var statusText = "init";
  int clickCounter = 0;
  var tempInterval = 0;
  var _isLoading = true;
  late User _currentUser = User.init();
  bool _showAbteilungList = false;
  late OpeningHoursSummary _openingHours = OpeningHoursSummary.init();
  late Bureaus _pickedBureau;

  late TabController _tabController;
  ScrollController _scrollControllerAbteilung = new ScrollController();

  var currentTabIndex = 0;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKeyAbteilung = GlobalKey();
  final GlobalKey<FormState> _formKeyAdmin = GlobalKey();

//Used for managing the different openinHours
  Map<String, String?> _openingHoursData = {
    'init': 'test',
    'init2': 'test2',
  };

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    asyncLoadingData();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    setState(() {
      currentTabIndex = _tabController.index;
    });
  }

  void asyncLoadingData() async {
    setState(() {
      _isLoading = true;
    });
    _openingHours = await adminCalls.getOpeningHours(_currentUser.token);
    _pickedBureau = _openingHours.bureaus![0];
    setState(() {
      _isLoading = false;
    });
  }

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
        height: 500,
        constraints: BoxConstraints(minHeight: 500, minWidth: 500),
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
                  actions: <Widget>[
                    (() {
                      if (currentTabIndex == 1) {
                        return InkWell(
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                if (_showAbteilungList == false) {
                                  _showAbteilungList = true;
                                  _scrollControllerAbteilung.animateTo(
                                    200.0,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                } else {
                                  _showAbteilungList = false;
                                }
                              });
                            },
                          ),
                        );
                      } else
                        return Container();
                    }()),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
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
                    controller: _tabController,
                    children: [
                      openingHours(_currentUser.token, "Kommune"),
                      openingHours(_currentUser.token, "Abteilung"),
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

  Widget openingHours(token, tabType) {
    /*if (tabType == "Kommune") {*/
    ///  }
    if (_isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (tabType == "Kommune") {
      return Container(
        //color: Colors.red,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GeneralWeekOpeningHours(_openingHours.name, _openingHours),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text('Speichern'),
                onPressed: () => {_submit(_openingHours.name, _formKey)},
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    } else
      return Container(
        child: Form(
          key: _formKeyAbteilung,
          child: ListView(
            controller: _scrollControllerAbteilung,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(_pickedBureau.name),
              ),
              GeneralWeekOpeningHours(_pickedBureau.name, _pickedBureau),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text(
                  'Speichern',
                ),
                onPressed: () =>
                    {_submit(_pickedBureau.name, _formKeyAbteilung)},
              ),
              SizedBox(
                height: 20,
              ),
              (() {
                if (_showAbteilungList == true) {
                  return Container(
                    height: 200,
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              "Abteilungen",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          height: 0,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _openingHours.bureaus?.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        _openingHours.bureaus![index].name),
                                    onTap: () {
                                      _pickedBureau =
                                          _openingHours.bureaus![index];
                                      setState(() {
                                        _showAbteilungList = false;
                                      });
                                    },
                                  ),
                                  Divider(
                                    height: 0,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else
                  return Container();
              }()),
            ],
          ),
        ),
      );
  }

  Widget GeneralWeekOpeningHours(id, _openingHours) {
    return Column(
      children: [
        SingleRowCallConfig(
            id,
            "Montag",
            _openingHours.openingHours[0].morningOpen,
            _openingHours.openingHours[0].morningClose,
            _openingHours.openingHours[0].afternoonOpen,
            _openingHours.openingHours[0].afternoonClose),
        SingleRowCallConfig(
            id,
            "Dienstag",
            _openingHours.openingHours[1].morningOpen,
            _openingHours.openingHours[1].morningClose,
            _openingHours.openingHours[1].afternoonOpen,
            _openingHours.openingHours[1].afternoonClose),
        SingleRowCallConfig(
            id,
            "Mittwoch",
            _openingHours.openingHours[2].morningOpen,
            _openingHours.openingHours[2].morningClose,
            _openingHours.openingHours[2].afternoonOpen,
            _openingHours.openingHours[2].afternoonClose),
        SingleRowCallConfig(
            id,
            "Donnerstag",
            _openingHours.openingHours[3].morningOpen,
            _openingHours.openingHours[3].morningClose,
            _openingHours.openingHours[3].afternoonOpen,
            _openingHours.openingHours[3].afternoonClose),
        SingleRowCallConfig(
            id,
            "Freitag",
            _openingHours.openingHours[4].morningOpen,
            _openingHours.openingHours[4].morningClose,
            _openingHours.openingHours[4].afternoonOpen,
            _openingHours.openingHours[4].afternoonClose),
      ],
    );
  }

  Widget SingleRowCallConfig(id, weekday, _morningOpen, _morningClose,
      _afternoonOpen, _afternoonClose) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
                _openingHoursData[id + '_' + weekday + '_morningOpen'] = value;
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
                _openingHoursData[id + '_' + weekday + '_morningClose'] = value;
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
                _openingHoursData[id + '_' + weekday + '_afternoonOpen'] =
                    value;
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
            onSaved: (value) {
              if (value != null) {
                _openingHoursData[id + '_' + weekday + '_afternoonClose'] =
                    value;
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _submit(id, formKeySubmit) async {
    if (!formKeySubmit.currentState!.validate()) {
      // Invali
      return;
    }
    formKeySubmit.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    //Idee: Hier ein Temp machen, und am Ende das Temp am richtigen ort einzügen!
    List<OpeningHours> temp = _openingHours
        .openingHours; //Change to picked! <-------------------------------------------------------------------------
    //Montag
    if (_openingHoursData[id + '_Montag_morningOpen'] != "") {
      temp[0].morningOpen =
          _openingHoursData[id + '_Montag_morningOpen']!.toString();
    }
    if (_openingHoursData[id + '_Montag_morningClose'] != "") {
      temp[0].morningClose =
          _openingHoursData[id + '_Montag_morningClose']!.toString();
    }
    if (_openingHoursData[id + '_Montag_afternoonOpen'] != "") {
      temp[0].afternoonOpen =
          _openingHoursData[id + '_Montag_afternoonOpen']!.toString();
    }
    if (_openingHoursData[id + '_Montag_afternoonClose'] != "") {
      temp[0].afternoonClose =
          _openingHoursData[id + '_Montag_afternoonClose']!.toString();
    }
    //Dienstag
    if (_openingHoursData[id + '_Dienstag_morningOpen'] != "") {
      temp[1].morningOpen =
          _openingHoursData[id + '_Dienstag_morningOpen']!.toString();
    }
    if (_openingHoursData[id + '_Dienstag_morningClose'] != "") {
      temp[1].morningClose =
          _openingHoursData[id + '_Dienstag_morningClose']!.toString();
    }
    if (_openingHoursData[id + '_Dienstag_afternoonOpen'] != "") {
      temp[1].afternoonOpen =
          _openingHoursData[id + '_Dienstag_afternoonOpen']!.toString();
    }
    if (_openingHoursData[id + '_Dienstag_afternoonClose'] != "") {
      temp[1].afternoonClose =
          _openingHoursData[id + '_Dienstag_afternoonClose']!.toString();
    }
    //Mittwoch
    if (_openingHoursData[id + '_Mittwoch_morningOpen'] != "") {
      temp[2].morningOpen =
          _openingHoursData[id + '_Mittwoch_morningOpen']!.toString();
    }
    if (_openingHoursData[id + '_Mittwoch_morningClose'] != "") {
      temp[2].morningClose =
          _openingHoursData[id + '_Mittwoch_morningClose']!.toString();
    }
    if (_openingHoursData[id + '_Mittwoch_afternoonOpen'] != "") {
      temp[2].afternoonOpen =
          _openingHoursData[id + '_Mittwoch_afternoonOpen']!.toString();
    }
    if (_openingHoursData[id + '_Mittwoch_afternoonClose'] != "") {
      temp[2].afternoonClose =
          _openingHoursData[id + '_Mittwoch_afternoonClose']!.toString();
    }
    //Donnerstag
    if (_openingHoursData[id + '_Donnerstag_morningOpen'] != "") {
      temp[3].morningOpen =
          _openingHoursData[id + '_Donnerstag_morningOpen']!.toString();
    }
    if (_openingHoursData[id + '_Donnerstag_morningClose'] != "") {
      temp[3].morningClose =
          _openingHoursData[id + '_Donnerstag_morningClose']!.toString();
    }
    if (_openingHoursData[id + '_Donnerstag_afternoonOpen'] != "") {
      temp[3].afternoonOpen =
          _openingHoursData[id + '_Donnerstag_afternoonOpen']!.toString();
    }
    if (_openingHoursData[id + '_Donnerstag_afternoonClose'] != "") {
      temp[3].afternoonClose =
          _openingHoursData[id + '_Donnerstag_afternoonClose']!.toString();
    }
    //Freitag
    if (_openingHoursData[id + '_Freitag_morningOpen'] != "") {
      temp[4].morningOpen =
          _openingHoursData[id + '_Freitag_morningOpen']!.toString();
    }
    if (_openingHoursData[id + '_Freitag_morningClose'] != "") {
      temp[4].morningClose =
          _openingHoursData[id + '_Freitag_morningClose']!.toString();
    }
    if (_openingHoursData[id + '_Freitag_afternoonOpen'] != "") {
      temp[4].afternoonOpen =
          _openingHoursData[id + '_Freitag_afternoonOpen']!.toString();
    }
    if (_openingHoursData[id + '_Freitag_afternoonClose'] != "") {
      temp[4].afternoonClose =
          _openingHoursData[id + '_Freitag_afternoonClose']!.toString();
    }
//TODO: Input temp on the Right place! <-----------------------------------------------------------------

    await AdminCalls().setOpeningHours(_currentUser.token, _openingHours);
    await AdminCalls().getOpeningHours(_currentUser.token);
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

class _BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            height: 70,
            child: Center(
              child: Text(
                "GalleryLocalizations.of(context).demoBottomSheetHeader",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: ListView.builder(
              itemCount: 21,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("hi"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
