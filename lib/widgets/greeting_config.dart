import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';

class GreetingConfigurationWidget extends StatefulWidget {
  final deviceSize;
  final User currentUser;
  const GreetingConfigurationWidget(this.deviceSize, this.currentUser);

  @override
  _GreetingConfigurationState createState() => _GreetingConfigurationState();
}

class _GreetingConfigurationState extends State<GreetingConfigurationWidget>
    with
        SingleTickerProviderStateMixin /*SingleTickerProviderStateMixin used for TabController vsync*/ {
  AdminCalls adminCalls = AdminCalls();

  late ConfigurartionSummary _greetingConfiguration =
      ConfigurartionSummary.init();

  late Bureaus _pickedBureau;
  late User _pickedUser;

  bool _showAbteilungList = false;
  bool _showNummerList = false;

  bool _isLoading = false;

  int currentTabIndex = 0;
  late TabController _tabController;

  final Map<String, dynamic> _greetingData = {
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
    _greetingConfiguration =
        await adminCalls.getGreetingConfiguration(widget.currentUser.token);
    /* _greetingConfiguration =
        await MyMockupDataProvider().getMockupData(context);*/
    _pickedBureau = _greetingConfiguration.bureaus![0];
    _pickedUser = _greetingConfiguration.users[0];
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
        width: widget.deviceSize.width * 0.3,
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
                  title: const Text("Begrüssung konfigurieren"),
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
                    greetingTabWidget(widget.currentUser.token, "Kommune"),
                    greetingTabWidget(widget.currentUser.token, "Abteilung"),
                    greetingTabWidget(widget.currentUser.token, "Nummer"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget greetingTabWidget(token, tabType) {
    final GlobalKey<FormState> _formKeyOrganization = GlobalKey();
    final GlobalKey<FormState> _formKeyBureau = GlobalKey();
    final GlobalKey<FormState> _formKeyNumber = GlobalKey();
    final ScrollController _scrollControllerBureau = ScrollController();
    final ScrollController _scrollControllerNumber = ScrollController();

    if (_isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (tabType == "Kommune") {
      return Form(
        key: _formKeyOrganization,
        child: ListView(
          children: [
            SizedBox(
              height: 25,
            ),
            generalGreetingConfigurationWidget(_greetingConfiguration.name!,
                _greetingConfiguration.greetingConfiguration),
            const SizedBox(
              height: 20,
            ),
            Align(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => {
                    _submit(
                      _greetingConfiguration.name,
                      //_formKey,
                      tabType,
                    ),
                  },
                  child: const Text('Speichern'),
                ),
              ),
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
          key: _formKeyBureau,
          child: ListView(
            controller: _scrollControllerBureau,
            children: [
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  _pickedBureau.name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              generalGreetingConfigurationWidget(
                  _pickedBureau.name, _pickedBureau.greetingConfiguration),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => {
                      _submit(_pickedBureau.name, /*_formKeyBureau,*/ tabType),
                    },
                    child: const Text(
                      'Speichern',
                    ),
                  ),
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
                  itemCount: _greetingConfiguration.bureaus?.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title:
                              Text(_greetingConfiguration.bureaus![index].name),
                          trailing: CupertinoSwitch(
                            onChanged: (bool value) {
                              setState(() {
                                _greetingConfiguration.bureaus![index]
                                    .activeGreetingConfiguration = value;
                              });
                              _submitActiveGreeting(
                                  _greetingConfiguration.bureaus?[index].name,
                                  value,
                                  tabType);
                            },
                            value: _greetingConfiguration
                                .bureaus![index].activeGreetingConfiguration!,
                          ),
                          onTap: () {
                            _pickedBureau =
                                _greetingConfiguration.bureaus![index];
                            setState(() {
                              _showAbteilungList = false;
                              _greetingConfiguration.bureaus![index]
                                          .activeGreetingConfiguration ==
                                      true
                                  ? _greetingConfiguration.bureaus![index]
                                          .activeGreetingConfiguration =
                                      _greetingConfiguration.bureaus![index]
                                          .activeGreetingConfiguration
                                  : _greetingConfiguration.bureaus![index]
                                          .activeGreetingConfiguration =
                                      _greetingConfiguration.bureaus![index]
                                          .activeGreetingConfiguration;
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
        key: _formKeyNumber,
        child: ListView(
          controller: _scrollControllerNumber,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                _pickedUser.username!,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            generalGreetingConfigurationWidget(
                _pickedUser.username!, _pickedUser.greetingConfiguration),
            const SizedBox(
              height: 20,
            ),
            Align(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => {
                    _submit(
                      _pickedUser.username,
                      /*_formKeyNumber,*/
                      tabType,
                    )
                  },
                  child: const Text(
                    'Speichern',
                  ),
                ),
              ),
            )
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
                itemCount: _greetingConfiguration.users.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title:
                            Text(_greetingConfiguration.users[index].username!),
                        trailing: CupertinoSwitch(
                          onChanged: (bool value) {
                            setState(() {
                              _greetingConfiguration.users[index]
                                  .activeGreetingConfiguration = value;
                            });
                            _submitActiveGreeting(
                                _greetingConfiguration.users[index].username,
                                value,
                                tabType);
                          },
                          value: _greetingConfiguration
                              .users[index].activeGreetingConfiguration!,
                        ),
                        onTap: () {
                          _pickedUser = _greetingConfiguration.users[index];
                          setState(() {
                            _showNummerList = false;
                            _greetingConfiguration.users[index]
                                        .activeGreetingConfiguration ==
                                    true
                                ? _greetingConfiguration.users[index]
                                        .activeGreetingConfiguration =
                                    !_greetingConfiguration.users[index]
                                        .activeGreetingConfiguration!
                                : _greetingConfiguration.users[index]
                                        .activeGreetingConfiguration =
                                    _greetingConfiguration.users[index]
                                        .activeGreetingConfiguration;
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

  Widget generalGreetingConfigurationWidget(
      String id, GreetingConfiguration? greetingConfig,
      {String? bureau,
      String? department,
      String? organization,
      String? salutation}) {
    _greetingData[id + "_Bureau"] == null
        ? _greetingData[id + "_Bureau"] = greetingConfig?.bureau
        : null;
    _greetingData[id + "_Department"] == null
        ? _greetingData[id + "_Department"] = greetingConfig?.department
        : null;
    _greetingData[id + "_Vorname"] == null
        ? _greetingData[id + "_Vorname"] = greetingConfig?.firstName
        : null;
    _greetingData[id + "_Nachname"] == null
        ? _greetingData[id + "_Nachname"] = greetingConfig?.lastName
        : null;
    _greetingData[id + "_Organization"] == null
        ? _greetingData[id + "_Organization"] = greetingConfig?.organizationName
        : null;
    _greetingData[id + "_Begrüssung"] == null
        ? _greetingData[id + "_Begrüssung"] = greetingConfig?.salutation
        : null;
    return Column(
      children: [
        singleRowConfig(id, "Bureau", greetingConfig?.bureau),
        singleRowConfig(id, "Department", greetingConfig?.department),
        singleRowConfig(id, "Vorname", greetingConfig?.firstName),
        singleRowConfig(id, "Nachname", greetingConfig?.lastName),
        singleRowConfig(id, "Organization", greetingConfig?.organizationName),
        singleRowConfig(id, "Begrüssung", greetingConfig?.salutation),
        //singleRowCallConfig(id, "Bureau", greetingConfig.organizationName),
      ],
    );
  }

  Widget singleRowConfig(id, String inhalt, bool? greetingConfigBoolean) {
    //Used for managing the different openinHours
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 40,
          width: 100,
          child: Text(inhalt),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 40,
          width: 60,
          child: Checkbox(
            value: _greetingData[id + '_' + inhalt],
            onChanged: (value) {
              setState(() {
                _greetingData[id + '_' + inhalt] = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Future<void> _submitActiveGreeting(id, activeGreeting, tabType) async {
    setState(() {
      _isLoading = true;
    });
    if (tabType == "Abteilung") {
      _greetingConfiguration.bureaus?.forEach((element) {
        if (element.name == id) {
          element.activeGreetingConfiguration = activeGreeting;
        }
      });
    } else if (tabType == "Nummer") {
      _greetingConfiguration.users.forEach((element) {
        if (element.username == id) {
          element.activeGreetingConfiguration = activeGreeting;
        }
      });
    }
    await AdminCalls().setGreetingConfiguration(
        widget.currentUser.token, _greetingConfiguration);
    await AdminCalls().getGreetingConfiguration(widget.currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submit(id, /*formKeySubmit,*/ tabType) async {
    /*if (!formKeySubmit.currentState!.validate()) {
      // Invali
      return;
    } */
    // formKeySubmit.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    GreetingConfiguration? temp = null;
    //Idee: Hier ein Temp machen, und am Ende das Temp am richtigen ort einzügen!
    if (tabType == "Kommune") {
      temp = _greetingConfiguration.greetingConfiguration!;
    } else if (tabType == "Abteilung") {
      _greetingConfiguration.bureaus?.forEach((element) {
        if (element.name == id) {
          temp = element.greetingConfiguration;
        }
      });
    } else if (tabType == "Nummer") {
      _greetingConfiguration.users.forEach((element) {
        if (element.username == id) {
          temp = element.greetingConfiguration;
        }
      });
    } else {
      throw Exception("Unbekannter TabType");
    }
    //Change to picked! <-------------------------------------------------------------------------
    //Montag
    if (_greetingData[id + "_Bureau"] != null) {
      temp?.bureau = _greetingData[id + "_Bureau"];
    }
    if (_greetingData[id + "_Department"] != null) {
      temp?.department = _greetingData[id + "_Department"];
    }
    if (_greetingData[id + "_Vorname"] != null) {
      temp?.firstName = _greetingData[id + "_Vorname"];
    }
    if (_greetingData[id + "_Nachname"] != null) {
      temp?.lastName = _greetingData[id + "_Nachname"];
    }
    if (_greetingData[id + "_Organization"] != null) {
      temp?.organizationName = _greetingData[id + "_Organization"];
    }
    if (_greetingData[id + "_Begrüssung"] != null) {
      temp?.salutation = _greetingData[id + "_Begrüssung"];
    }

    // Save temp on the right place!
    if (tabType == "Kommune") {
      _greetingConfiguration.greetingConfiguration = temp;
    } else if (tabType == "Abteilung") {
      _greetingConfiguration.bureaus?.forEach((element) {
        if (element.name == id) {
          element.greetingConfiguration = temp;
        }
      });
    } else if (tabType == "Nummer") {
      //To be tested!
      //TODO: Exactly same thing as for Abeilung
      _greetingConfiguration.users.forEach((element) {
        if (element.username == id) {
          element.greetingConfiguration = temp;
        }
      });
      //----------------------<<< To be tested
    } else {
      throw Exception("Unbekannter TabType");
    }
    await AdminCalls().setGreetingConfiguration(
        widget.currentUser.token, _greetingConfiguration);
    await AdminCalls().getGreetingConfiguration(widget.currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }
}
