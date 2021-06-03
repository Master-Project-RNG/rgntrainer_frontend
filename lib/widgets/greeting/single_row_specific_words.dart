import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

class SingleRowSpecWordsConfig extends StatefulWidget {
  final id;
  final String inhalt;
  final List<String> specificWords;
  final String tabType;
  SingleRowSpecWordsConfig(this.id, String this.inhalt,
      List<String> this.specificWords, this.tabType);

  @override
  _SingleRowSpecWordsConfigState createState() =>
      _SingleRowSpecWordsConfigState();
}

class _SingleRowSpecWordsConfigState extends State<SingleRowSpecWordsConfig> {
  bool _isLoadingPopUpMenu = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  late User _currentUser;

  @override
  initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
  }

  get items {
    if (_isLoadingPopUpMenu) {
      return Container(
        height: 500,
        width: 500,
        color: Colors.red,
        child: CircularProgressIndicator(),
      );
    } else {
      return List.generate(
        widget.specificWords.length,
        (index) {
          return PopupMenuItem(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => {
                        setState(() {
                          _formKey.currentState?.save();
                        })
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      (widget.specificWords[index]),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
  }

  List<String> totalItem = ["Test1", "test"];
  bool deleted = false;
  @override
  Widget build(BuildContext context) {
    final AdminCallsProvider myAdminCallProvider =
        context.watch<AdminCallsProvider>();
    if (_isLoadingPopUpMenu == true) {
      return Container(
        height: 500,
        width: 500,
        color: Colors.red,
        child: CircularProgressIndicator(),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: 100,
            child: Text("Spezifische Wörter"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 120,
                height: 100,
                child: (_isLoadingPopUpMenu)
                    ? Container(
                        height: 500,
                        width: 500,
                        color: Colors.red,
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        child: PopupMenuButton(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          itemBuilder: (context) {
                            return totalItem
                                .map((item) => PopupMenuItem(child:
                                        StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              '${item}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                totalItem.add("test");
                                              });
                                            },
                                            child: Icon(
                                              Icons.add_circle,
                                              color: Colors.green,
                                            ),
                                          ),
                                          Text(
                                            item.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                decoration: deleted
                                                    ? TextDecoration.lineThrough
                                                    : null),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                totalItem.add("test");
                                                deleted = !deleted;
                                              });
                                            },
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      );
                                    })))
                                .toList();
                          },
                          /*..add(
                              PopupMenuItem(
                                child: Form(
                                  key: _formKey,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () => {
                                          _formKey.currentState?.save(),
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        width: 120,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Neues Wort",
                                          ),
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          cursorHeight: 20,
                                          onSaved: (value) {
                                            if (value != null) {
                                              // _greetingData[id + '_specificWords'].add(value);
                                              setState(() {
                                                _submitSpecificWords(
                                                    widget.id,
                                                    widget.tabType,
                                                    value,
                                                    myAdminCallProvider
                                                        .greetingConfigurationSummary,
                                                    widget.currentUser);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );*/
                        ),
                      ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Future<void> _submitSpecificWords(
      id, tabType, value, _greetingConfiguration, currentUser) async {
    setState(() {
      _isLoadingPopUpMenu = true;
    });
    if (tabType == "Kommune") {
      _greetingConfiguration.greetingConfiguration?.specificWords.add(value);
    } else if (tabType == "Abteilung") {
      _greetingConfiguration.bureaus?.forEach((element) {
        if (element.name == id) {
          element.greetingConfiguration?.specificWords.add(value);
        }
      });
    } else if (tabType == "Nummer") {
      _greetingConfiguration.users.forEach((element) {
        if (element.username == id) {
          element.greetingConfiguration?.specificWords.add(value);
        }
      });
    }
    await AdminCallsProvider()
        .setGreetingConfiguration(_currentUser.token, _greetingConfiguration);
    await AdminCallsProvider().getGreetingConfiguration(_currentUser.token);
    setState(() {
      _isLoadingPopUpMenu = false;
      items;
    });
  }
}
