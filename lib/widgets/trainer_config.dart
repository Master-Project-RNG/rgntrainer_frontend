import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/callRange.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

class TrainerConfiguration extends StatefulWidget {
  final deviceSize;
  const TrainerConfiguration(this.deviceSize);

  @override
  _TrainerConfigurationState createState() => _TrainerConfigurationState();
}

class _TrainerConfigurationState extends State<TrainerConfiguration> {
  var tempInterval = 0;
  var adminCalls = AdminCallsProvider();
  late User _currentUser = User.init();
  late CallRange _callRange = CallRange.init();
  var _isLoading = false;

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
    _callRange = await Provider.of<AdminCallsProvider>(context, listen: false)
        .getCallRange(_currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 280, minWidth: 500),
      height: 550,
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
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          'Min Calls:',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SpinBox(
                                min: 0,
                                max: 99,
                                value: _callRange.minCalls.toDouble(),
                                onChanged: (value) {
                                  _callRange.minCalls = value.toInt();
                                },
                              ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          'Max Calls:',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SpinBox(
                                min: 0,
                                max: 99,
                                value: _callRange.maxCalls.toDouble(),
                                onChanged: (value) {
                                  _callRange.maxCalls = value.toInt();
                                },
                              ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          'minDaysBetweenCallsSingleNumber:',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SpinBox(
                                min: 0,
                                max: 99,
                                value: _callRange
                                    .minDaysBetweenCallsSingleNumber
                                    .toDouble(),
                                onChanged: (value) {
                                  _callRange.minDaysBetweenCallsSingleNumber =
                                      value.toInt();
                                },
                              ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          'maxHoursForCallBack:',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SpinBox(
                                min: 0,
                                max: 99,
                                value:
                                    _callRange.maxHoursForCallback.toDouble(),
                                onChanged: (value) {
                                  _callRange.maxHoursForCallback =
                                      value.toInt();
                                },
                              ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          'Pause zw. den Anrufen in Sekunden:',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SpinBox(
                                min: 0,
                                max: 600,
                                value:
                                    _callRange.secondsBetweenCalls.toDouble(),
                                onChanged: (value) {
                                  _callRange.secondsBetweenCalls =
                                      value.toInt();
                                },
                              ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      _submit(_currentUser.token!, _callRange),
                    },
                    child: const Text('Speichern'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green, onPrimary: Colors.white),
                          onPressed: () {
                            adminCalls.startTrainer(
                                tempInterval, _currentUser.token);
                            setState(() {
                              getStatus(_currentUser.token!);
                            });
                            print('Short Press!');
                          },
                          child: const Text('Start'),
                        ),
                      ),
                      getStatus(_currentUser.token!),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red, onPrimary: Colors.white),
                          onPressed: () {
                            adminCalls.stopTrainer(_currentUser.token);
                            setState(() {
                              getStatus(_currentUser.token!);
                            });
                            // ignore: avoid_print
                            print('Short Press!');
                          },
                          child: const Text('Stop'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          'Resultate:',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, onPrimary: Colors.white),
                          child: Text('Download'),
                          onPressed: () {
                            print('Short Press!');
                            adminCalls.getResults(_currentUser.token);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit(token, CallRange callRange) async {
    setState(() {
      _isLoading = true;
    });
    await AdminCallsProvider().setCallRange(token, callRange);
    await AdminCallsProvider().getCallRange(token);
    setState(() {
      _isLoading = false;
    });
  }

  // _status has to be connected to the class attribute _status in order that setState() works, can't be handed in as a function parameter ;)
  Widget getStatus(String token) {
    return FutureBuilder<bool>(
        future: adminCalls.getTrainerStatus(token),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            //TODO: TESTEN
            if (snapshot.data == true) {
              var statusText = 'Status: Eingeschaltet';
              return SizedBox(
                width: 200,
                child: Text(
                  statusText,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              var statusText = 'Status: Ausgeschaltet';
              return SizedBox(
                width: 200,
                child: Text(
                  statusText,
                  textAlign: TextAlign.center,
                ),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
