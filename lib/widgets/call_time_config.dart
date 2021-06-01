import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rgntrainer_frontend/models/opening_hours_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:rgntrainer_frontend/utils/validator.dart';

class CallTimeConfiguration extends StatefulWidget {
  final deviceSize;
  final User currentUser;
  const CallTimeConfiguration(this.deviceSize, this.currentUser);

  @override
  _CallTimeConfigurationState createState() => _CallTimeConfigurationState();
}

class _CallTimeConfigurationState extends State<CallTimeConfiguration>
    with
        SingleTickerProviderStateMixin /*SingleTickerProviderStateMixin used for TabController vsync*/ {
  final ScrollController _scrollControllerAbteilung = ScrollController();
  final ScrollController _scrollControllerNummer = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKeyAbteilung = GlobalKey();
  final GlobalKey<FormState> _formKeyNummer = GlobalKey();

  late OpeningHoursSummary _openingHours = OpeningHoursSummary.init();
  late Bureaus _pickedBureau;
  late User _pickedUser;

  bool _showAbteilungList = false;
  bool _showNummerList = false;

  bool _isLoading = false;

  int currentTabIndex = 0;
  late TabController _tabController;

  AdminCalls adminCalls = AdminCalls();

//Used for managing the different openinHours
  final Map<String, String?> _openingHoursData = {
    'init': 'test',
    'init2': 'test2',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    asyncLoadingData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> asyncLoadingData() async {
    setState(() {
      _isLoading = true;
    });
    _openingHours = await adminCalls.getOpeningHours(widget.currentUser.token);
    _pickedBureau = _openingHours.bureaus![0];
    _pickedUser = _openingHours.users[0];
    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabSelection() {
    setState(() {
      currentTabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        height: 520,
        constraints: const BoxConstraints(minHeight: 520, minWidth: 500),
        width: widget.deviceSize.width * 0.5,
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  title: const Text("Anrufzeit konfigurieren"),
                  centerTitle: true,
                  elevation: 8.0,
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    (() {
                      if (currentTabIndex == 1) {
                        return InkWell(
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                if (_showAbteilungList == false) {
                                  _showAbteilungList = true;
                                  _scrollControllerAbteilung.animateTo(
                                    320.0,
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
                      } else if (currentTabIndex == 2) {
                        return InkWell(
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                if (_showNummerList == false) {
                                  _showNummerList = true;
                                } else {
                                  _showNummerList = false;
                                }
                              });
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }()),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: const [
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
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    openingHours(widget.currentUser.token, "Kommune"),
                    openingHours(widget.currentUser.token, "Abteilung"),
                    openingHours(widget.currentUser.token, "Nummer"),
                  ],
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (tabType == "Kommune") {
      return
          //color: Colors.red,
          Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            generalWeekOpeningHours(_openingHours.name!, _openingHours),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => {
                _submit(
                  _openingHours.name,
                  _formKey,
                  tabType,
                ),
              },
              child: const Text('Speichern'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    } else if (tabType == "Abteilung") {
      if (_showAbteilungList == false) {
        return Form(
          key: _formKeyAbteilung,
          child: ListView(
            controller: _scrollControllerAbteilung,
            children: [
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  _pickedBureau.name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              generalWeekOpeningHours(_pickedBureau.name, _pickedBureau),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => {
                  _submit(_pickedBureau.name, _formKeyAbteilung, tabType),
                },
                child: const Text(
                  'Speichern',
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          height: 400,
          child: Column(
            children: [
              const Divider(
                thickness: 1,
                height: 0,
              ),
              Container(
                height: 50,
                child: const Center(
                  child: Text(
                    "Abteilungen",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
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
                          title: Text(_openingHours.bureaus![index].name),
                          trailing: CupertinoSwitch(
                            onChanged: (bool value) {
                              setState(() {
                                _openingHours
                                    .bureaus![index].activeOpeningHours = value;
                              });
                              _submitActiveOpeningHours(
                                  _openingHours.bureaus![index].name,
                                  value,
                                  tabType);
                            },
                            value: _openingHours
                                .bureaus![index].activeOpeningHours!,
                          ),
                          onTap: () {
                            _pickedBureau = _openingHours.bureaus![index];
                            setState(() {
                              _showAbteilungList = false;
                              _openingHours
                                          .bureaus![index].activeOpeningHours ==
                                      true
                                  ? _openingHours
                                          .bureaus![index].activeOpeningHours =
                                      _openingHours
                                          .bureaus![index].activeOpeningHours
                                  : _openingHours
                                          .bureaus![index].activeOpeningHours =
                                      _openingHours
                                          .bureaus![index].activeOpeningHours;
                            });
                          },
                        ),
                        const Divider(
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
      }
    } else //Nummer
    if (_showNummerList == false) {
      return Container(
          child: Form(
        key: _formKeyNummer,
        child: ListView(
          controller: _scrollControllerNummer,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                _pickedUser.username!,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            generalWeekOpeningHours(_pickedUser.username!, _pickedUser),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => {
                _submit(
                  _pickedUser.username,
                  _formKeyNummer,
                  tabType,
                )
              },
              child: const Text(
                'Speichern',
              ),
            ),
          ],
        ),
      ));
    } else {
      return Container(
        height: 400,
        child: Column(
          children: [
            const Divider(
              thickness: 1,
              height: 0,
            ),
            Container(
              height: 50,
              child: const Center(
                child: Text(
                  "Nummer",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _openingHours.users.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_openingHours.users[index].username!),
                        trailing: CupertinoSwitch(
                          onChanged: (bool value) {
                            setState(() {
                              _openingHours.users[index].activeOpeningHours =
                                  value;
                            });
                            _submitActiveOpeningHours(
                                _openingHours.users[index].username,
                                value,
                                tabType);
                          },
                          value: _openingHours.users[index].activeOpeningHours,
                        ),
                        onTap: () {
                          _pickedUser = _openingHours.users[index];
                          setState(() {
                            _showNummerList = false;
                            _openingHours.users[index].activeOpeningHours ==
                                    true
                                ? _openingHours
                                        .users[index].activeOpeningHours =
                                    !_openingHours
                                        .users[index].activeOpeningHours
                                : _openingHours
                                        .users[index].activeOpeningHours =
                                    _openingHours
                                        .users[index].activeOpeningHours;
                          });
                        },
                      ),
                      const Divider(
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
    }
  }

  Widget generalWeekOpeningHours(String id, _openingHours) {
    return Column(
      children: [
        singleRowCallConfig(
            id,
            "Montag",
            _openingHours.openingHours[0].morningOpen,
            _openingHours.openingHours[0].morningClose,
            _openingHours.openingHours[0].afternoonOpen,
            _openingHours.openingHours[0].afternoonClose),
        singleRowCallConfig(
            id,
            "Dienstag",
            _openingHours.openingHours[1].morningOpen,
            _openingHours.openingHours[1].morningClose,
            _openingHours.openingHours[1].afternoonOpen,
            _openingHours.openingHours[1].afternoonClose),
        singleRowCallConfig(
            id,
            "Mittwoch",
            _openingHours.openingHours[2].morningOpen,
            _openingHours.openingHours[2].morningClose,
            _openingHours.openingHours[2].afternoonOpen,
            _openingHours.openingHours[2].afternoonClose),
        singleRowCallConfig(
            id,
            "Donnerstag",
            _openingHours.openingHours[3].morningOpen,
            _openingHours.openingHours[3].morningClose,
            _openingHours.openingHours[3].afternoonOpen,
            _openingHours.openingHours[3].afternoonClose),
        singleRowCallConfig(
            id,
            "Freitag",
            _openingHours.openingHours[4].morningOpen,
            _openingHours.openingHours[4].morningClose,
            _openingHours.openingHours[4].afternoonOpen,
            _openingHours.openingHours[4].afternoonClose),
      ],
    );
  }

  Widget singleRowCallConfig(id, String weekday, String _morningOpen,
      String _morningClose, String _afternoonOpen, String _afternoonClose) {
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
          child: const Text("von "),
        ),
        Container(
          alignment: Alignment.topCenter,
          height: 50,
          width: 60,
          child: TextFormField(
            decoration: InputDecoration(
                counter: const Offstage(),
                hintText: _morningOpen.substring(0, 5),
                errorStyle: const TextStyle()),
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

  Future<void> _submitActiveOpeningHours(
      id, activeOpeningHours, tabType) async {
    print("_submitActiveOpeningHours!");
    setState(() {
      _isLoading = true;
    });
    if (tabType == "Abteilung") {
      _openingHours.bureaus?.forEach((element) {
        if (element.name == id) {
          element.activeOpeningHours = activeOpeningHours;
        }
      });
    } else if (tabType == "Nummer") {
      _openingHours.users.forEach((element) {
        if (element.username == id) {
          element.activeOpeningHours = activeOpeningHours;
        }
      });
    }
    await AdminCalls().setOpeningHours(widget.currentUser.token, _openingHours);
    await AdminCalls().getOpeningHours(widget.currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submit(id, formKeySubmit, tabType) async {
    if (!formKeySubmit.currentState!.validate()) {
      // Invali
      return;
    }
    formKeySubmit.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    List<OpeningHours> temp = [];
    //Idee: Hier ein Temp machen, und am Ende das Temp am richtigen ort einzügen!
    if (tabType == "Kommune") {
      temp = _openingHours.openingHours;
    } else if (tabType == "Abteilung") {
      _openingHours.bureaus?.forEach((element) {
        if (element.name == id) {
          temp = element.openingHours!;
        }
      });
    } else if (tabType == "Nummer") {
      _openingHours.users.forEach((element) {
        if (element.username == id) {
          temp = element.openingHours!;
        }
      });
    } else {
      throw Exception("Unbekannter TabType");
    }
    //Change to picked! <-------------------------------------------------------------------------
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
    // Save temp on the right place!
    if (tabType == "Kommune") {
      _openingHours.openingHours = temp;
    } else if (tabType == "Abteilung") {
      _openingHours.bureaus?.forEach((element) {
        if (element.name == id) {
          element.openingHours = temp;
        }
      });
    } else if (tabType == "Nummer") {
      //To be tested!
      //TODO: Exactly same thing as for Abeilung
      _openingHours.users.forEach((element) {
        if (element.username == id) {
          element.openingHours = temp;
        }
      });
      //----------------------<<< To be tested
    } else {
      throw Exception("Unbekannter TabType");
    }
    await AdminCalls().setOpeningHours(widget.currentUser.token, _openingHours);
    await AdminCalls().getOpeningHours(widget.currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }
}
