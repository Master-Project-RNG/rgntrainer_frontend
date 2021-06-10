import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

class SingleRowSpecWordsConfig extends StatefulWidget {
  final String id;
  final String inhalt;
  final List<String> specificWords;
  final String tabType;
  final Map<String, dynamic> greetingData;
  const SingleRowSpecWordsConfig(this.id, this.inhalt, this.specificWords,
      this.tabType, this.greetingData);

  @override
  _SingleRowSpecWordsConfigState createState() =>
      _SingleRowSpecWordsConfigState();
}

class _SingleRowSpecWordsConfigState extends State<SingleRowSpecWordsConfig> {
  bool _isLoadingPopUpMenu = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
  }

  bool deleted = false;
  @override
  Widget build(BuildContext context) {
    List<String> specificWordsTemp = List.of(widget.specificWords);
    final AdminCallsProvider myAdminCallProvider =
        context.watch<AdminCallsProvider>();
    if (_isLoadingPopUpMenu == true) {
      return Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: 150,
            child: Text(
                "Spezifische Wörter (${widget.specificWords.length.toString()})"),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 145,
                child: _isLoadingPopUpMenu
                    ? Container(
                        height: 50,
                        width: 50,
                        child: const CircularProgressIndicator(),
                      )
                    : (widget.specificWords.length == 0)
                        ? Center(child: Text("Keine Wörter!"))
                        : PopupMenuButton(
                            itemBuilder: (context) {
                              return List.generate(
                                widget.specificWords.length,
                                (index) {
                                  return PopupMenuItem(
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            (isInOriginal(
                                                    widget.specificWords[index],
                                                    specificWordsTemp))
                                                ? IconButton(
                                                    onPressed: () => {
                                                      setState(() {
                                                        removeSpecificWords(
                                                          widget.specificWords[
                                                              index],
                                                          specificWordsTemp,
                                                        );
                                                      })
                                                    },
                                                    icon: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            (isInOriginal(
                                                    widget.specificWords[index],
                                                    specificWordsTemp))
                                                ? Text(
                                                    widget.specificWords[index],
                                                  )
                                                : Text(
                                                    widget.specificWords[index],
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const Text('Wörter anzeigen')
                              ],
                            )),
              ),
              Form(
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
                        textAlignVertical: TextAlignVertical.center,
                        cursorHeight: 20,
                        onSaved: (value) {
                          if (value != null) {
                            // _greetingData[id + '_specificWords'].add(value);
                            setState(() {
                              addSpecificWords(
                                value,
                                specificWordsTemp,
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  removeSpecificWords(String value, List<String> specificWordsTemp) {
    specificWordsTemp
        .removeWhere((element) => element == value || element == "");
    widget.greetingData['${widget.id}_${widget.inhalt}'] = specificWordsTemp;
  }

  addSpecificWords(String value, List<String> specificWordsTemp) {
    widget.specificWords.add(value);
    specificWordsTemp.add(value);
    widget.greetingData['${widget.id}_${widget.inhalt}'] = specificWordsTemp;
  }

  bool isInOriginal(String item, List<String> all) {
    if (all.contains(item)) {
      return true;
    } else {
      return false;
    }
  }
}
