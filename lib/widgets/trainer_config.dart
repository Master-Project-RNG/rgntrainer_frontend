import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/call_range.dart';
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
  int tempInterval = 0;
  AdminCallsProvider adminCalls = AdminCallsProvider();
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
        .getCallRange(_currentUser.token!);
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
            SizedBox(
              height: 50,
              child: AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                title: const Text(
                  "Trainer starten",
                  style: TextStyle(color: Colors.white),
                ),
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
                      const SizedBox(
                        width: 300,
                        child: Text(
                          'Minimale Anzahl Anrufe:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: _isLoading
                            ? const Center(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 300,
                        child: Text(
                          'Maximale Anzahl Anrufe:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: _isLoading
                            ? const Center(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 300,
                        child: Text(
                          'Minimale Anzahl Tage zwischen Anrufen einer einzelnen Nummer:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: _isLoading
                            ? const Center(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 300,
                        child: Text(
                          'Anzahl Stunden bis ein Rückruf als zu spät gilt:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : SpinBox(
                                min: 0,
                                max: 999,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 300,
                        child: Text(
                          'Pause zwischen den Anrufen (generell) in Sekunden:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: _isLoading
                            ? const Center(
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
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => {
                        _submit(_currentUser.token!, _callRange),
                      },
                      child: const Text('Speichern'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(String token, CallRange callRange) async {
    setState(() {
      _isLoading = true;
    });
    await AdminCallsProvider().setCallRange(token, callRange);
    await AdminCallsProvider().getCallRange(token);
    setState(() {
      _isLoading = false;
    });
  }
}
