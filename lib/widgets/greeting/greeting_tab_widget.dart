import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

import 'general_greeting.dart';

class GreetingTabWidget extends StatefulWidget {
  final String tabType;
  final bool _showAbteilungList;
  final bool _showNummerList;

  GreetingTabWidget(
      String this.tabType, this._showAbteilungList, this._showNummerList);

  @override
  _GreetingTabWidgetState createState() => _GreetingTabWidgetState();
}

class _GreetingTabWidgetState extends State<GreetingTabWidget> {
  final GlobalKey<FormState> _formKeyOrganization = GlobalKey();
  final GlobalKey<FormState> _formKeyBureau = GlobalKey();
  final GlobalKey<FormState> _formKeyNumber = GlobalKey();
  final ScrollController _scrollControllerBureau = ScrollController();
  final ScrollController _scrollControllerNumber = ScrollController();

  bool _isLoading = false;
  late User _currentUser = User.init();

  @override
  initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    asyncLoadingData();
  }

  Future asyncLoadingData() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<AdminCallsProvider>(context, listen: false)
        .getGreetingConfiguration(_currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AdminCallsProvider myAdminCallProvider =
        context.watch<AdminCallsProvider>();
    if (_isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (widget.tabType == "Kommune") {
      return Form(
        key: _formKeyOrganization,
        child: ListView(
          children: [
            SizedBox(
              height: 25,
            ),
            GeneralGreetingConfigurationWidget(
                myAdminCallProvider.getGreetingConfigurationSummary.name!,
                myAdminCallProvider
                    .getGreetingConfigurationSummary.greetingConfiguration,
                widget.tabType,
                myAdminCallProvider.getGreetingData),
            const SizedBox(
              height: 20,
            ),
            Align(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => {
                    _submit(
                      myAdminCallProvider.getGreetingConfigurationSummary.name,
                      //_formKey,
                      widget.tabType,
                      myAdminCallProvider.getGreetingConfigurationSummary,
                      myAdminCallProvider.getGreetingData,
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
    } else if (widget.tabType == "Abteilung") {
      if (widget._showAbteilungList == false) {
        return Form(
          key: _formKeyBureau,
          child: ListView(
            controller: _scrollControllerBureau,
            children: [
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  myAdminCallProvider.getPickerBureauGreeting.name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              GeneralGreetingConfigurationWidget(
                  myAdminCallProvider.getPickerBureauGreeting.name,
                  myAdminCallProvider
                      .getPickerBureauGreeting.greetingConfiguration,
                  widget.tabType,
                  myAdminCallProvider.getGreetingData),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => {
                      _submit(
                          myAdminCallProvider.getPickerBureauGreeting.name,
                          /*_formKeyBureau,*/ widget.tabType,
                          myAdminCallProvider.getGreetingConfigurationSummary,
                          myAdminCallProvider.getGreetingData),
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
                  itemCount: myAdminCallProvider
                      .getGreetingConfigurationSummary.bureaus?.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(myAdminCallProvider
                              .getGreetingConfigurationSummary
                              .bureaus![index]
                              .name),
                          trailing: CupertinoSwitch(
                            onChanged: (bool value) {
                              setState(() {
                                myAdminCallProvider
                                    .getGreetingConfigurationSummary
                                    .bureaus![index]
                                    .activeGreetingConfiguration = value;
                              });
                              _submitActiveGreeting(
                                  myAdminCallProvider
                                      .getGreetingConfigurationSummary
                                      .bureaus?[index]
                                      .name,
                                  value,
                                  widget.tabType,
                                  myAdminCallProvider
                                      .getGreetingConfigurationSummary);
                            },
                            value: myAdminCallProvider
                                .getGreetingConfigurationSummary
                                .bureaus![index]
                                .activeGreetingConfiguration!,
                          ),
                          onTap: () {
                            myAdminCallProvider.setPickerBureauGreeting(
                                myAdminCallProvider
                                    .getGreetingConfigurationSummary
                                    .bureaus![index]);
                            ;
                            setState(() {
                              myAdminCallProvider
                                          .getGreetingConfigurationSummary
                                          .bureaus![index]
                                          .activeGreetingConfiguration ==
                                      true
                                  ? myAdminCallProvider
                                          .getGreetingConfigurationSummary
                                          .bureaus![index]
                                          .activeGreetingConfiguration =
                                      myAdminCallProvider
                                          .getGreetingConfigurationSummary
                                          .bureaus![index]
                                          .activeGreetingConfiguration
                                  : myAdminCallProvider
                                          .getGreetingConfigurationSummary
                                          .bureaus![index]
                                          .activeGreetingConfiguration =
                                      myAdminCallProvider
                                          .getGreetingConfigurationSummary
                                          .bureaus![index]
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
    if (widget._showNummerList == false) {
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
                myAdminCallProvider.getPickerUserGreeting.username!,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            GeneralGreetingConfigurationWidget(
                myAdminCallProvider.getPickerUserGreeting.username!,
                myAdminCallProvider.getPickerUserGreeting.greetingConfiguration,
                widget.tabType,
                myAdminCallProvider.getGreetingData),
            const SizedBox(
              height: 20,
            ),
            Align(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => {
                    _submit(
                      myAdminCallProvider.getPickerUserGreeting.username,
                      /*_formKeyNumber,*/
                      widget.tabType,
                      myAdminCallProvider.getGreetingConfigurationSummary,
                      myAdminCallProvider.getGreetingData,
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
                itemCount: myAdminCallProvider
                    .getGreetingConfigurationSummary.users.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(myAdminCallProvider
                            .getGreetingConfigurationSummary
                            .users[index]
                            .username!),
                        trailing: CupertinoSwitch(
                          onChanged: (bool value) {
                            setState(() {
                              myAdminCallProvider
                                  .getGreetingConfigurationSummary
                                  .users[index]
                                  .activeGreetingConfiguration = value;
                            });
                            _submitActiveGreeting(
                                myAdminCallProvider
                                    .getGreetingConfigurationSummary
                                    .users[index]
                                    .username,
                                value,
                                widget.tabType,
                                myAdminCallProvider
                                    .getGreetingConfigurationSummary);
                          },
                          value: myAdminCallProvider
                              .getGreetingConfigurationSummary
                              .users[index]
                              .activeGreetingConfiguration!,
                        ),
                        onTap: () {
                          myAdminCallProvider.setPickedUserGreeting(
                              myAdminCallProvider
                                  .getGreetingConfigurationSummary
                                  .users[index]);
                          setState(() {
                            myAdminCallProvider
                                        .getGreetingConfigurationSummary
                                        .users[index]
                                        .activeGreetingConfiguration ==
                                    true
                                ? myAdminCallProvider
                                        .getGreetingConfigurationSummary
                                        .users[index]
                                        .activeGreetingConfiguration =
                                    !myAdminCallProvider
                                        .getGreetingConfigurationSummary
                                        .users[index]
                                        .activeGreetingConfiguration!
                                : myAdminCallProvider
                                        .getGreetingConfigurationSummary
                                        .users[index]
                                        .activeGreetingConfiguration =
                                    myAdminCallProvider
                                        .getGreetingConfigurationSummary
                                        .users[index]
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

  Future<void> _submit(id, /*formKeySubmit,*/ tabType, _greetingConfiguration,
      _greetingData) async {
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
      _greetingConfiguration.bureaus?.forEach(
        (element) {
          if (element.name == id) {
            element.greetingConfiguration = temp;
          }
        },
      );
    } else if (tabType == "Nummer") {
      _greetingConfiguration.users.forEach(
        (element) {
          if (element.username == id) {
            element.greetingConfiguration = temp;
          }
        },
      );
    } else {
      throw Exception("Unbekannter TabType");
    }
    await AdminCallsProvider()
        .setGreetingConfiguration(_currentUser.token, _greetingConfiguration);
    await AdminCallsProvider().getGreetingConfiguration(_currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submitActiveGreeting(
      id, activeGreeting, tabType, _greetingConfiguration) async {
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
    await AdminCallsProvider()
        .setGreetingConfiguration(_currentUser.token, _greetingConfiguration);
    await AdminCallsProvider().getGreetingConfiguration(_currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }
}
