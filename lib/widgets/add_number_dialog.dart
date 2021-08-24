import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_numbers_provider.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

Future<bool?> addNumberDialog<bool>(
  BuildContext context, {
  required List<String> bureauNames,
}) =>
    showDialog<bool>(
      context: context,
      builder: (context) => TextDialogWidget(
        bureauNames: bureauNames,
      ),
    );

class TextDialogWidget extends StatefulWidget {
  final List<String> bureauNames;

  const TextDialogWidget({
    Key? key,
    required this.bureauNames,
  }) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late User _currentUser = User.init();

  late TextEditingController controllerNumber;
  late TextEditingController controllerDepartment;
  late TextEditingController controllerFirstName;
  late TextEditingController controllerLastName;
  late TextEditingController controllerEmail;

  final String number = "";
  final String department = "";
  final String firstName = "";
  final String lastName = "";
  final String email = "";

  String pickedBureau = '';
  int selectedQueryType = 0; //pickedBureau index for dropdownmenu

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    controllerNumber = TextEditingController();
    controllerDepartment = TextEditingController();
    controllerFirstName = TextEditingController();
    controllerLastName = TextEditingController();
    controllerEmail = TextEditingController();
  }

  @override
  void dispose() {
    controllerNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Center(
            child: Text(
          "Neue Nummer erfassen",
          style: TextStyle(fontSize: 30),
        )),
        content: Container(
          height: 380,
          width: 600,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(width: 100, child: Text("Büro")),
                  Expanded(
                    child: PopupMenuButton(
                      onSelected: (result) {
                        setState(() {
                          selectedQueryType = result as int;
                          pickedBureau = widget.bureauNames[result];
                        });
                      },
                      itemBuilder: (context) {
                        return List.generate(
                          widget.bureauNames.length,
                          (index) {
                            return PopupMenuItem(
                              value: index,
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 240,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        widget.bureauNames[index].toString(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: DropdownButton(
                          value: this.selectedQueryType,
                          items: getDropdownMenuItemList(widget.bureauNames),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text("Nummer"),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controllerNumber,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text("Abteilung"),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controllerDepartment,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text("Vorname"),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controllerFirstName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text("Nachname"),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controllerLastName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text("Email"),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controllerEmail,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Provider.of<NumbersProvider>(context, listen: false).createUser(
                token: _currentUser.token!,
                number: controllerNumber.text,
                bureau: widget.bureauNames[selectedQueryType],
                allBureaus: widget.bureauNames,
                department: controllerDepartment.text,
                firstName: controllerFirstName.text,
                lastName: controllerLastName.text,
                email: controllerEmail.text,
                ctx: context,
              );
            },
            child: const Text('Speichern'),
          )
        ],
      );

  List<DropdownMenuItem> getDropdownMenuItemList(List<String> bureauNames) {
    List<DropdownMenuItem> result = [];
    for (int i = 0; i < bureauNames.length; i++) {
      result.add(
        DropdownMenuItem(
          child: Container(
            alignment: Alignment.centerLeft,
            width: 210,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  bureauNames[i],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          value: i,
        ),
      );
    }
    return result;
  }
}
