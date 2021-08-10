import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/status_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/widgets/ui/calendar_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/navbar_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/title_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CockpitScreen extends StatefulWidget {
  @override
  _CockpitScreenState createState() => _CockpitScreenState();
}

class _CockpitScreenState extends State<CockpitScreen> {
  late User _currentUser = User.init();
  AdminCallsProvider adminCalls = AdminCallsProvider();
  late Status _status = Status.init();

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    gedAsyncStatus();
    initializeDateFormatting(); //Set language of CalendarWidget to German
  }

  gedAsyncStatus() async {
    Status _status = await adminCalls.getTrainerStatus(_currentUser.token!);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  // _status has to be connected to the class attribute _status in order that setState() works, can't be handed in as a function parameter ;)
  Widget getStatus(String token) {
    return FutureBuilder<Status>(
        future: adminCalls.getTrainerStatus(token),
        builder: (context, AsyncSnapshot<Status> snapshot) {
          if (snapshot.hasData) {
            //TODO: TESTEN
            if (snapshot.data!.status == true) {
              _status.status = true;
              _status.startedAt = snapshot.data!.startedAt;
              var statusText = 'Status: Eingeschaltet';
              return SizedBox(
                child: Text(
                  statusText,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              _status.status = false;
              _status.startedAt = snapshot.data!.startedAt;
              var statusText = 'Der Trainer ist ausgeschaltet.';
              return SizedBox(
                child: Text(
                  statusText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w200,
                    fontSize: 16,
                  ),
                ),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser.token == null || _currentUser.usertype != "admin") {
      return NoTokenScreen();
    } else {
      return Row(
        children: [
          NavBarWidget(_currentUser),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 65,
                titleSpacing:
                    0, //So that the title start right away at the left side
                title: CalendarWidget(),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.vxNav.push(
                        Uri.parse(MyRoutes.adminProfilRoute),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      AuthProvider().logout(_currentUser.token!);
                      context.vxNav.clearAndPush(
                        Uri.parse(MyRoutes.loginRoute),
                      );
                    },
                  )
                ],
                automaticallyImplyLeading: false,
              ),
              body: ListView(
                children: [
                  TitleWidget("Cockpit"),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(20),
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        color: Colors.grey[100],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: _status.status == false
                                                      ? Center(
                                                          child: getStatus(
                                                              _currentUser
                                                                  .token!),
                                                        )
                                                      : Center(
                                                          child: StreamBuilder(
                                                            stream:
                                                                Stream.periodic(
                                                                    const Duration(
                                                                        seconds:
                                                                            1)),
                                                            builder: (context,
                                                                snapshot) {
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      "Der Trainer läuft seit"),
                                                                  SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Text(
                                                                    _printDuration(DateTime
                                                                            .now()
                                                                        .difference(
                                                                            _status.startedAt)),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        child: Column(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  primary:
                                                      _status.status == false
                                                          ? Colors.green
                                                          : Colors.green[200],
                                                  onPrimary: Colors.white),
                                              onPressed: () {
                                                adminCalls.startTrainer(
                                                    _currentUser.token!);
                                                setState(() {
                                                  getStatus(
                                                      _currentUser.token!);
                                                });
                                                print('Short Press!');
                                              },
                                              child: const Text('Start'),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  primary:
                                                      _status.status == false
                                                          ? Colors.red[200]
                                                          : Colors.red,
                                                  onPrimary: Colors.white),
                                              onPressed: () {
                                                adminCalls.stopTrainer(
                                                    _currentUser.token!);
                                                setState(() {
                                                  getStatus(
                                                      _currentUser.token!);
                                                });
                                                // ignore: avoid_print
                                                print('Short Press!');
                                              },
                                              child: const Text('Stop'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(20),
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.cyan,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
