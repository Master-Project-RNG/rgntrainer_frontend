import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';
import 'package:rgntrainer_frontend/models/diagram_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/screens/components/line_chart.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

class LineChartSample1 extends StatefulWidget {
  LineChartSample1();

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  int selectedQueryType = 0;
  late List<String> _getBureausNames = [];
  late User _currentUser;
  bool _isLoadingInit = true;
  bool _isLoadingDiagram = false;
  late List<Diagram> diagramResults;

  Map<String, bool> showChartLine = {
    'totalCalls': true,
    'totalCallsReached': true,
    'rateSaidOrganization': true,
    'rateSaidBureau': true,
    'rateSaidDepartment': true,
    'rateSaidFirstname': true,
    'rateSaidName': true,
    'rateSaidGreeting': true,
    'rateSaidSpecificWords': true,
    'rateReached': true,
    'rateCallCompleted': true,
  };

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    isShowingMainData = true;
    getAsyncData();
  }

  getAsyncData() async {
    _getBureausNames =
        await Provider.of<BureauResultsProvider>(context, listen: false)
            .getBureausNames(_currentUser.token);
    selectedQueryType = _getBureausNames.indexWhere((element) =>
        element == "Overall"); //Set standart of selected dropdown to "Overall"
    diagramResults =
        await Provider.of<BureauResultsProvider>(context, listen: false)
            .getTotalResultsWeekly(
                _currentUser.token, _getBureausNames[selectedQueryType]);
    setState(() {
      _isLoadingInit = false;
    });
  }

  updateAsyncData() async {
    setState(() {
      _isLoadingDiagram = true;
    });
    diagramResults =
        await Provider.of<BureauResultsProvider>(context, listen: false)
            .getTotalResultsWeekly(
                _currentUser.token, _getBureausNames[selectedQueryType]);
    setState(() {
      _isLoadingDiagram = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color:
                        Colors.black.withOpacity(isShowingMainData ? 1.0 : 0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      isShowingMainData = !isShowingMainData;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Normaler Anruf',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 4,
            ),
            _isLoadingInit
                ? Container()
                : SizedBox(
                    width: 240,
                    height: 50,
                    child: PopupMenuButton(
                      onSelected: (result) {
                        setState(() {
                          selectedQueryType = result as int;
                          updateAsyncData();
                        });
                      },
                      itemBuilder: (context) {
                        return List.generate(
                          _getBureausNames.length,
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
                                        _getBureausNames[index].toString(),
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
                          items: getDropdownMenuItemList(_getBureausNames),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 37,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                child: (_isLoadingDiagram || _isLoadingInit) == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : MyLineChart(
                        isShowingMainData: isShowingMainData,
                        selectedQueryType: selectedQueryType,
                        diagramResults: diagramResults,
                        showChartLine: showChartLine,
                      ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            isShowingMainData
                ? Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 200,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 4,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        maxCrossAxisExtent: 200,
                      ),
                      children: elevatedButtonsNormalCall,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 200,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 4,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        maxCrossAxisExtent: 200,
                      ),
                      children: elevatedButtonRateCall,
                    ),
                  )
          ],
        ),
      ),
    );
  }

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
                  _getBureausNames[i],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
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

  List<Widget> get elevatedButtonsNormalCall {
    return [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateSaidOrganization'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateSaidOrganization"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateSaidOrganization'] == true
                ? showChartLine['rateSaidOrganization'] = false
                : showChartLine['rateSaidOrganization'] = true;
          });
        },
        child: Text(
          BureauStatistics
              .bureauStatisticsTranslationToGerman["rateSaidOrganization"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateSaidBureau'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateSaidBureau"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateSaidBureau'] == true
                ? showChartLine['rateSaidBureau'] = false
                : showChartLine['rateSaidBureau'] = true;
          });
        },
        child: Text(
          BureauStatistics
              .bureauStatisticsTranslationToGerman["rateSaidBureau"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateSaidDepartment'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateSaidDepartment"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateSaidDepartment'] == true
                ? showChartLine['rateSaidDepartment'] = false
                : showChartLine['rateSaidDepartment'] = true;
          });
        },
        child: Text(
          BureauStatistics
              .bureauStatisticsTranslationToGerman["rateSaidDepartment"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateSaidFirstname'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateSaidFirstname"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateSaidFirstname'] == true
                ? showChartLine['rateSaidFirstname'] = false
                : showChartLine['rateSaidFirstname'] = true;
          });
        },
        child: Text(
          BureauStatistics
              .bureauStatisticsTranslationToGerman["rateSaidFirstname"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateSaidName'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateSaidName"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateSaidName'] == true
                ? showChartLine['rateSaidName'] = false
                : showChartLine['rateSaidName'] = true;
          });
        },
        child: Text(
          BureauStatistics.bureauStatisticsTranslationToGerman["rateSaidName"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateSaidGreeting'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateSaidGreeting"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateSaidGreeting'] == true
                ? showChartLine['rateSaidGreeting'] = false
                : showChartLine['rateSaidGreeting'] = true;
          });
        },
        child: Text(
          BureauStatistics
              .bureauStatisticsTranslationToGerman["rateSaidGreeting"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateSaidSpecificWords'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateSaidSpecificWords"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateSaidSpecificWords'] == true
                ? showChartLine['rateSaidSpecificWords'] = false
                : showChartLine['rateSaidSpecificWords'] = true;
          });
        },
        child: Text(
          BureauStatistics
              .bureauStatisticsTranslationToGerman["rateSaidSpecificWords"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateReached'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateReached"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateReached'] == true
                ? showChartLine['rateReached'] = false
                : showChartLine['rateReached'] = true;
          });
        },
        child: Text(
          BureauStatistics.bureauStatisticsTranslationToGerman["rateReached"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['rateCallCompleted'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["rateCallCompleted"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['rateCallCompleted'] == true
                ? showChartLine['rateCallCompleted'] = false
                : showChartLine['rateCallCompleted'] = true;
          });
        },
        child: Text(
          BureauStatistics
              .bureauStatisticsTranslationToGerman["rateCallCompleted"]!,
          textAlign: TextAlign.center,
        ),
      )
    ];
  }

  List<Widget> get elevatedButtonRateCall {
    return [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['totalCalls'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics.bureauStatisticsDiagramColors["totalCalls"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['totalCalls'] == true
                ? showChartLine['totalCalls'] = false
                : showChartLine['totalCalls'] = true;
          });
        },
        child: Text(
          BureauStatistics.bureauStatisticsTranslationToGerman["totalCalls"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLine['totalCallsReached'] == true
              ? MaterialStateProperty.all<Color>(
                  BureauStatistics
                      .bureauStatisticsDiagramColors["totalCallsReached"]!,
                )
              : MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            showChartLine['totalCallsReached'] == true
                ? showChartLine['totalCallsReached'] = false
                : showChartLine['totalCallsReached'] = true;
          });
        },
        child: Text(
          BureauStatistics
              .bureauStatisticsTranslationToGerman["totalCallsReached"]!,
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }
}
