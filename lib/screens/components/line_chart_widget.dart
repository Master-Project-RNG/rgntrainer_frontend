import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';
import 'package:rgntrainer_frontend/models/diagram_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/screens/components/line_chart.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

class LineChartWidget extends StatefulWidget {
  final String diagramType;
  LineChartWidget({required this.diagramType});

  @override
  State<StatefulWidget> createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  late bool isShowingMainData;
  int selectedQueryType = 0;
  late List<String> _getBureausNames = [];
  late User _currentUser;
  bool _isLoadingInit = true;
  bool _isLoadingDiagram = false;
  late List<Diagram> diagramResults;

  Map<String, bool> showChartLineStandart = {
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

  Map<String, bool> showChartLineAB = {
    "rateSaidOrganizationAB": true,
    "rateSaidBureauAB": true,
    "rateSaidDepartmentAB": true,
    "rateSaidFirstnameAB": true,
    "rateSaidNameAB": true,
    "rateSaidGreetingAB": true,
    "rateSaidSpecificWordsAB": true,
    "rateResponderStartedIfNotReached": true,
    "rateResponderCorrect": true,
    "rateCallbackDoneNoAnswer": true,
    "rateCallbackDoneResponder": true,
    "rateCallbackDoneUnexpected": true,
    "rateCallbackDoneOverall": true,
    "rateCallbackInTime": true,
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
        constraints: BoxConstraints(minHeight: 800),
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
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.black
                          .withOpacity(isShowingMainData ? 1.0 : 0.5),
                    ),
                    onPressed: () {
                      setState(() {
                        isShowingMainData = !isShowingMainData;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                widget.diagramType,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _isLoadingInit
                ? Container()
                : Expanded(
                    flex: 1,
                    child: SizedBox(
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
                  ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 8,
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
                        showChartLineStandartStandart: showChartLineStandart,
                        showChartLineAB: showChartLineAB,
                        diagramType: widget.diagramType,
                      ),
              ),
            ),
            isShowingMainData
                ? Expanded(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          childAspectRatio: 4,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          maxCrossAxisExtent: 200,
                        ),
                        children: widget.diagramType == "Standart"
                            ? elevatedButtonsNormalCall //"Standart"
                            : elevatedButtonsAB, //"Anrufbeantworter"
                      ),
                    ),
                  )
                : Expanded(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          childAspectRatio: 4,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          maxCrossAxisExtent: 200,
                        ),
                        children: elevatedButtonRateCall,
                      ),
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
          backgroundColor: showChartLineStandart['rateSaidOrganization'] == true
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
            showChartLineStandart['rateSaidOrganization'] == true
                ? showChartLineStandart['rateSaidOrganization'] = false
                : showChartLineStandart['rateSaidOrganization'] = true;
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
          backgroundColor: showChartLineStandart['rateSaidBureau'] == true
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
            showChartLineStandart['rateSaidBureau'] == true
                ? showChartLineStandart['rateSaidBureau'] = false
                : showChartLineStandart['rateSaidBureau'] = true;
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
          backgroundColor: showChartLineStandart['rateSaidDepartment'] == true
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
            showChartLineStandart['rateSaidDepartment'] == true
                ? showChartLineStandart['rateSaidDepartment'] = false
                : showChartLineStandart['rateSaidDepartment'] = true;
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
          backgroundColor: showChartLineStandart['rateSaidFirstname'] == true
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
            showChartLineStandart['rateSaidFirstname'] == true
                ? showChartLineStandart['rateSaidFirstname'] = false
                : showChartLineStandart['rateSaidFirstname'] = true;
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
          backgroundColor: showChartLineStandart['rateSaidName'] == true
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
            showChartLineStandart['rateSaidName'] == true
                ? showChartLineStandart['rateSaidName'] = false
                : showChartLineStandart['rateSaidName'] = true;
          });
        },
        child: Text(
          BureauStatistics.bureauStatisticsTranslationToGerman["rateSaidName"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineStandart['rateSaidGreeting'] == true
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
            showChartLineStandart['rateSaidGreeting'] == true
                ? showChartLineStandart['rateSaidGreeting'] = false
                : showChartLineStandart['rateSaidGreeting'] = true;
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
          backgroundColor: showChartLineStandart['rateSaidSpecificWords'] ==
                  true
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
            showChartLineStandart['rateSaidSpecificWords'] == true
                ? showChartLineStandart['rateSaidSpecificWords'] = false
                : showChartLineStandart['rateSaidSpecificWords'] = true;
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
          backgroundColor: showChartLineStandart['rateReached'] == true
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
            showChartLineStandart['rateReached'] == true
                ? showChartLineStandart['rateReached'] = false
                : showChartLineStandart['rateReached'] = true;
          });
        },
        child: Text(
          BureauStatistics.bureauStatisticsTranslationToGerman["rateReached"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineStandart['rateCallCompleted'] == true
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
            showChartLineStandart['rateCallCompleted'] == true
                ? showChartLineStandart['rateCallCompleted'] = false
                : showChartLineStandart['rateCallCompleted'] = true;
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

  List<Widget> get elevatedButtonsAB {
    return [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateSaidOrganizationAB'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateSaidOrganizationAB"]!,
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
            showChartLineAB['rateSaidOrganizationAB'] == true
                ? showChartLineAB['rateSaidOrganizationAB'] = false
                : showChartLineAB['rateSaidOrganizationAB'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateSaidOrganizationAB"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateSaidBureauAB'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics
                      .abAndCallbackStatisticDiagramColors["rateSaidBureauAB"]!,
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
            showChartLineAB['rateSaidBureauAB'] == true
                ? showChartLineAB['rateSaidBureauAB'] = false
                : showChartLineAB['rateSaidBureauAB'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics
              .abAndCallbackStatisticsTranslationToGerman["rateSaidBureauAB"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateSaidDepartmentAB'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateSaidDepartmentAB"]!,
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
            showChartLineAB['rateSaidDepartmentAB'] == true
                ? showChartLineAB['rateSaidDepartmentAB'] = false
                : showChartLineAB['rateSaidDepartmentAB'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateSaidDepartmentAB"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateSaidFirstnameAB'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateSaidFirstnameAB"]!,
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
            showChartLineAB['rateSaidFirstnameAB'] == true
                ? showChartLineAB['rateSaidFirstnameAB'] = false
                : showChartLineAB['rateSaidFirstnameAB'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateSaidFirstnameAB"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateSaidNameAB'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics
                      .abAndCallbackStatisticDiagramColors["rateSaidNameAB"]!,
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
            showChartLineAB['rateSaidNameAB'] == true
                ? showChartLineAB['rateSaidNameAB'] = false
                : showChartLineAB['rateSaidNameAB'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics
              .abAndCallbackStatisticsTranslationToGerman["rateSaidNameAB"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateSaidGreetingAB'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateSaidGreetingAB"]!,
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
            showChartLineAB['rateSaidGreetingAB'] == true
                ? showChartLineAB['rateSaidGreetingAB'] = false
                : showChartLineAB['rateSaidGreetingAB'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateSaidGreetingAB"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateSaidSpecificWordsAB'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateSaidSpecificWordsAB"]!,
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
            showChartLineAB['rateSaidSpecificWordsAB'] == true
                ? showChartLineAB['rateSaidSpecificWordsAB'] = false
                : showChartLineAB['rateSaidSpecificWordsAB'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateSaidSpecificWordsAB"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              showChartLineAB['rateResponderStartedIfNotReached'] == true
                  ? MaterialStateProperty.all<Color>(
                      AbAndCallbackStatistics
                              .abAndCallbackStatisticDiagramColors[
                          "rateResponderStartedIfNotReached"]!,
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
            showChartLineAB['rateResponderStartedIfNotReached'] == true
                ? showChartLineAB['rateResponderStartedIfNotReached'] = false
                : showChartLineAB['rateResponderStartedIfNotReached'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateResponderStartedIfNotReached"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateResponderCorrect'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateResponderCorrect"]!,
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
            showChartLineAB['rateResponderCorrect'] == true
                ? showChartLineAB['rateResponderCorrect'] = false
                : showChartLineAB['rateResponderCorrect'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateResponderCorrect"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateCallbackDoneNoAnswer'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateCallbackDoneNoAnswer"]!,
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
            showChartLineAB['rateCallbackDoneNoAnswer'] == true
                ? showChartLineAB['rateCallbackDoneNoAnswer'] = false
                : showChartLineAB['rateCallbackDoneNoAnswer'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateCallbackDoneNoAnswer"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateCallbackDoneResponder'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateCallbackDoneResponder"]!,
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
            showChartLineAB['rateCallbackDoneResponder'] == true
                ? showChartLineAB['rateCallbackDoneResponder'] = false
                : showChartLineAB['rateCallbackDoneResponder'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateCallbackDoneResponder"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateCallbackDoneUnexpected'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateCallbackDoneUnexpected"]!,
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
            showChartLineAB['rateCallbackDoneUnexpected'] == true
                ? showChartLineAB['rateCallbackDoneUnexpected'] = false
                : showChartLineAB['rateCallbackDoneUnexpected'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateCallbackDoneUnexpected"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateCallbackDoneOverall'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateCallbackDoneOverall"]!,
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
            showChartLineAB['rateCallbackDoneOverall'] == true
                ? showChartLineAB['rateCallbackDoneOverall'] = false
                : showChartLineAB['rateCallbackDoneOverall'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateCallbackDoneOverall"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineAB['rateCallbackInTime'] == true
              ? MaterialStateProperty.all<Color>(
                  AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
                      "rateCallbackInTime"]!,
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
            showChartLineAB['rateCallbackInTime'] == true
                ? showChartLineAB['rateCallbackInTime'] = false
                : showChartLineAB['rateCallbackInTime'] = true;
          });
        },
        child: Text(
          AbAndCallbackStatistics.abAndCallbackStatisticsTranslationToGerman[
              "rateCallbackInTime"]!,
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  List<Widget> get elevatedButtonRateCall {
    return [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineStandart['totalCalls'] == true
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
            showChartLineStandart['totalCalls'] == true
                ? showChartLineStandart['totalCalls'] = false
                : showChartLineStandart['totalCalls'] = true;
          });
        },
        child: Text(
          BureauStatistics.bureauStatisticsTranslationToGerman["totalCalls"]!,
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: showChartLineStandart['totalCallsReached'] == true
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
            showChartLineStandart['totalCallsReached'] == true
                ? showChartLineStandart['totalCallsReached'] = false
                : showChartLineStandart['totalCallsReached'] = true;
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
