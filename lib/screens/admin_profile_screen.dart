import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/widgets/ui/calendar_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/date_symbol_data_local.dart';

class AdminProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminProfileCard();
  }
}

class AdminProfileCard extends StatefulWidget {
  const AdminProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  _AdminCardState createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminProfileCard> {
  late User _currentUser = User.init();

  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;

  String oldPassword = "";
  String newPassword = "";
  String newPasswordConfirmed = "";

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    print(_currentUser.token);
    initializeDateFormatting(); //set CalendarWidget language to German
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    if (newPassword != newPasswordConfirmed) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Fehler!'),
          content: Text("Neue Passwörter stimmen nicht überein!"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Schliessen'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<AuthProvider>(context, listen: false).changePassword(
            context, _currentUser.token, oldPassword, newPassword);
      } catch (error) {
        debugPrint(error.toString());
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    if (_currentUser.token == null || _currentUser.usertype != "admin") {
      return NoTokenScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0, //So that the title start right away at the left side
          title: CalendarWidget(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list_alt),
              onPressed: () {
                context.vxNav.push(
                  Uri.parse(MyRoutes.adminResultsRoute),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.build_rounded),
              onPressed: () {
                context.vxNav.push(
                  Uri.parse(MyRoutes.adminRoute),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                AuthProvider().logout(_currentUser.token);
                context.vxNav.push(
                  Uri.parse(MyRoutes.loginRoute),
                );
              },
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 8.0,
                  child: Container(
                    constraints: BoxConstraints(minHeight: 260),
                    width: deviceSize.width * 0.5,
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Kennwort ändern',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Altes Passwort'),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ungültiger Benutzername!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                oldPassword = value!;
                              },
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Neues Password'),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'Passwort ist zu kurz! Verwende mindestens 6 Zeichen!';
                                }
                              },
                              onSaved: (value) {
                                newPassword = value!;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Neues Password bestätigen'),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'Passwort ist zu kurz! Verwende mindestens 6 Zeichen!';
                                }
                              },
                              onSaved: (value) {
                                newPasswordConfirmed = value!;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (_isLoading)
                              CircularProgressIndicator()
                            else
                              RaisedButton(
                                child: Text('Kennwort ändern'),
                                onPressed: _submit,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button!
                                    .color,
                              ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
