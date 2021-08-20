import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';
import 'package:rgntrainer_frontend/models/diagram_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:intl/intl.dart';

class MyLineChart extends StatefulWidget {
  final int selectedQueryType;
  final bool isShowingMainData;
  final List<Diagram> diagramResults;
  final Map<String, bool> showChartLineStandartStandart;
  final Map<String, bool> showChartLineAB;
  final String diagramType;

  const MyLineChart({
    required this.isShowingMainData,
    required this.selectedQueryType,
    required this.diagramResults,
    required this.showChartLineStandartStandart,
    required this.showChartLineAB,
    required this.diagramType,
  });

  @override
  _MyLineChartState createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  late User _currentUser = User.init();

  bool _isLoading = false;
  late List<int> _numericScalaTotalCalls = [];
  late List<String> _getBureausNames = [];

  final DateFormat formatter = DateFormat('dd.MM.yy');

  @override
  initState() {
    _currentUser = UserSimplePreferences.getUser();
    getAsyncData();
    super.initState();
  }

  getAsyncData() async {
    setState(() {
      _isLoading = true;
    });
    _getBureausNames =
        await Provider.of<BureauResultsProvider>(context, listen: false)
            .getBureausNames(_currentUser.token);
    _numericScalaTotalCalls = calculateNumericYAxis(widget.diagramResults);
    setState(() {
      _isLoading = false;
    });
  }

  /// Get the Y-axis of the numeric values e.g. Total Calls, Calls reached.
  /// @param List<Diagram>, List of data that will be displayed in the line chart.
  List<int> calculateNumericYAxis(List<Diagram> list) {
    double _max = 0;
    List<int> _result = [];
    for (int i = 0; i < list.length; i++) {
      _max < double.parse(list[i].bureauStatistics.totalCalls)
          ? _max = double.parse(list[i].bureauStatistics.totalCalls)
          : _max = _max;
    }
    int scalaMax = ((_max / 10) + 0.5).round() * 10;
    _result.add(((scalaMax / 4) + 0.5).round() * 1);
    _result.add(((scalaMax / 4) + 0.5).round() * 2);
    _result.add(((scalaMax / 4) + 0.5).round() * 3);
    _result.add(scalaMax);
    return _result;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Container(
        padding: EdgeInsets.all(25),
        child: LineChart(
          widget.isShowingMainData
              ? sampleDataRateValues
              : sampleDataNumericValues,
          swapAnimationDuration: const Duration(milliseconds: 250),
        ),
      );
  }

  LineChartData get sampleDataRateValues => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 10,
        ),
        titlesData: titlesDataRateValues,
        borderData: borderData,
        lineBarsData: widget.diagramType == "Standart"
            ? lineBarsDataRateValuesStandart
            : lineBarsDataRateValuesAB,
        minX: 0,
        maxX: 11,
        maxY: 100,
        minY: 0,
      );

  LineChartData get sampleDataNumericValues => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 5,
        ),
        titlesData: titlesDataNumericValues(_numericScalaTotalCalls),
        borderData: borderData,
        lineBarsData: lineBarsDataNumericValues,
        minX: 0,
        maxX: 11,
        maxY: double.parse(_numericScalaTotalCalls[3].toString()),
        minY: 0,
      );

  ///Used as a parameter in [LineChartData],
  ///can be used for rate values and numeric values both.
  LineTouchData get lineTouchData1 => LineTouchData(
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  ///Labeling of the Y and X axis
  ///Used as a parameter in [LineChartData]
  FlTitlesData get titlesDataRateValues => FlTitlesData(
        bottomTitles: bottomTitles,
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 10:
                return '10%';
              case 20:
                return '20%';
              case 30:
                return '30%';
              case 40:
                return '40%';
              case 50:
                return '50%';
              case 60:
                return '60%';
              case 70:
                return '70%';
              case 80:
                return '80%';
              case 90:
                return '90%';
              case 100:
                return '100%';
            }
            return '';
          },
        ),
      );

  ///Labeling of the Y and X axis
  ///Used as a parameter in [LineChartData]
  FlTitlesData titlesDataNumericValues(List<int> numericScalaTotalCalls) =>
      FlTitlesData(
        bottomTitles: bottomTitles,
        leftTitles: leftTitles(
          getTitles: (value) {
            if (value == numericScalaTotalCalls[0]) {
              return numericScalaTotalCalls[0].toString();
            }
            if (value == numericScalaTotalCalls[1]) {
              return numericScalaTotalCalls[1].toString();
            }
            if (value == numericScalaTotalCalls[2]) {
              return numericScalaTotalCalls[2].toString();
            }
            if (value == numericScalaTotalCalls[3]) {
              return numericScalaTotalCalls[3].toString();
            }
            return '';
          },
        ),
      );

  ///Labeling of the X axis
  ///Used as a parameter in [FlTitlesData]
  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        getTextStyles: (value) => TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        getTitles: (value) {
          int diagramLength = widget.diagramResults.length;
          for (int i = 0; i < diagramLength; i = i + 2) {
            if (value == i) {
              return formatter.format(widget.diagramResults[i].date).toString();
            }
          }
          return '';
        },
      );

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        reservedSize: 30,
        getTextStyles: (value) => TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  ///Used as a parameter in [LineChartData]
  ///Defines the border
  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.black, width: 2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  ///Used as a parameter in [LineChartData]
  ///Returns a list of Lines that should be drawn in the diagram.
  ///Handles the relevant data to be drawn!
  List<LineChartBarData> get lineBarsDataRateValuesStandart {
    int diagramLength = widget.diagramResults.length;
    return [
      if (widget.showChartLineStandartStandart['rateSaidOrganization'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidOrganization"]!,
          lineName: "rateSaidOrganization",
        ),
      if (widget.showChartLineStandartStandart['rateSaidBureau'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color:
              BureauStatistics.bureauStatisticsDiagramColors["rateSaidBureau"]!,
          lineName: "rateSaidBureau",
        ),
      if (widget.showChartLineStandartStandart['rateSaidDepartment'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidDepartment"]!,
          lineName: "rateSaidDepartment",
        ),
      if (widget.showChartLineStandartStandart['rateSaidFirstname'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidFirstname"]!,
          lineName: "rateSaidFirstname",
        ),
      if (widget.showChartLineStandartStandart['rateSaidName'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color:
              BureauStatistics.bureauStatisticsDiagramColors["rateSaidName"]!,
          lineName: "rateSaidName",
        ),
      if (widget.showChartLineStandartStandart['rateSaidGreeting'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidGreeting"]!,
          lineName: "rateSaidGreeting",
        ),
      if (widget.showChartLineStandartStandart['rateSaidSpecificWords'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidSpecificWords"]!,
          lineName: "rateSaidSpecificWords",
        ),
      if (widget.showChartLineStandartStandart['rateReached'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics.bureauStatisticsDiagramColors["rateReached"]!,
          lineName: "rateReached",
        ),
      if (widget.showChartLineStandartStandart['rateCallCompleted'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateCallCompleted"]!,
          lineName: "rateCallCompleted",
        ),
    ];
  }

  ///Used as a parameter in [LineChartData]
  ///Returns a list of Lines that should be drawn in the diagram.
  ///Handles the relevant data to be drawn!
  List<LineChartBarData> get lineBarsDataRateValuesAB {
    int diagramLength = widget.diagramResults.length;
    return [
      if (widget.showChartLineAB['rateSaidOrganizationAB'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateSaidOrganizationAB"]!,
          lineName: "rateSaidOrganizationAB",
        ),
      if (widget.showChartLineAB['rateSaidBureauAB'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateSaidBureauAB"]!,
          lineName: "rateSaidBureauAB",
        ),
      if (widget.showChartLineAB['rateSaidDepartmentAB'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateSaidDepartmentAB"]!,
          lineName: "rateSaidDepartmentAB",
        ),
      if (widget.showChartLineAB['rateSaidFirstnameAB'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateSaidFirstnameAB"]!,
          lineName: "rateSaidFirstnameAB",
        ),
      if (widget.showChartLineAB['rateSaidNameAB'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateSaidNameAB"]!,
          lineName: "rateSaidNameAB",
        ),
      if (widget.showChartLineAB['rateSaidGreetingAB'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateSaidGreetingAB"]!,
          lineName: "rateSaidGreetingAB",
        ),
      if (widget.showChartLineAB['rateSaidSpecificWordsAB'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateSaidSpecificWordsAB"]!,
          lineName: "rateSaidSpecificWordsAB",
        ),
      if (widget.showChartLineAB['rateResponderStartedIfNotReached'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
              "rateResponderStartedIfNotReached"]!,
          lineName: "rateResponderStartedIfNotReached",
        ),
      if (widget.showChartLineAB['rateResponderCorrect'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateResponderCorrect"]!,
          lineName: "rateResponderCorrect",
        ),
      if (widget.showChartLineAB['rateCallbackDoneNoAnswer'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateCallbackDoneNoAnswer"]!,
          lineName: "rateCallbackDoneNoAnswer",
        ),
      if (widget.showChartLineAB['rateCallbackDoneResponder'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
              "rateCallbackDoneResponder"]!,
          lineName: "rateCallbackDoneResponder",
        ),
      if (widget.showChartLineAB['rateCallbackDoneUnexpected'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics.abAndCallbackStatisticDiagramColors[
              "rateCallbackDoneUnexpected"]!,
          lineName: "rateCallbackDoneUnexpected",
        ),
      if (widget.showChartLineAB['rateCallbackDoneOverall'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateCallbackDoneOverall"]!,
          lineName: "rateCallbackDoneOverall",
        ),
      if (widget.showChartLineAB['rateCallbackInTime'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: AbAndCallbackStatistics
              .abAndCallbackStatisticDiagramColors["rateCallbackInTime"]!,
          lineName: "rateCallbackInTime",
        ),
    ];
  }

  ///Used as a parameter in [LineChartData]
  ///Returns a list of Lines that should be drawn in the diagram.
  ///Handles the relevant data to be drawn!
  List<LineChartBarData> get lineBarsDataNumericValues {
    int diagramLength = widget.diagramResults.length;
    return [
      if (widget.showChartLineStandartStandart['totalCalls'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics.bureauStatisticsDiagramColors["totalCalls"]!,
          lineName: "totalCalls",
        ),
      if (widget.showChartLineStandartStandart['totalCallsReached'] == true)
        lineChartBar(
          diagramLength: diagramLength,
          diagramResults: widget.diagramResults,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["totalCallsReached"]!,
          lineName: "totalCallsReached",
        ),
    ];
  }

  ///Creates the single lines for the lists [lineBarsDataRateValues] and [lineBarsDataNumericValues]
  LineChartBarData lineChartBar({
    required int diagramLength,
    required List<Diagram> diagramResults,
    required Color color,
    required String lineName,
  }) =>
      LineChartBarData(
        isCurved: false,
        colors: [color],
        barWidth: 4,
        isStrokeCapRound: false,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: widget.diagramType == "Standart"
            ? getFlSpotsStandart(
                diagramLength: diagramLength,
                diagramResults: diagramResults,
                lineName: lineName,
              )
            : getFlSpotsAB(
                diagramLength: diagramLength,
                diagramResults: diagramResults,
                lineName: lineName,
              ),
      );

  ///Creates single dots/data points per [lineName]
  List<FlSpot> getFlSpotsStandart(
      {required int diagramLength,
      required List<Diagram> diagramResults,
      required String lineName}) {
    final List<FlSpot> result = [];
    for (int i = 0; i < diagramLength; i++) {
      if (lineName == 'totalCalls') {
        if (diagramResults[i].bureauStatistics.totalCalls != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i].bureauStatistics.totalCalls),
            ),
          );
        }
      } else if (lineName == 'totalCallsReached') {
        if (diagramResults[i].bureauStatistics.totalCallsReached != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].bureauStatistics.totalCallsReached),
            ),
          );
        }
      } else if (lineName == 'rateSaidOrganization') {
        if (diagramResults[i].bureauStatistics.rateSaidOrganization != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].bureauStatistics.rateSaidOrganization),
            ),
          );
        }
      } else if (lineName == 'rateSaidBureau') {
        if (diagramResults[i].bureauStatistics.rateSaidBureau != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i].bureauStatistics.rateSaidBureau),
            ),
          );
        }
      } else if (lineName == 'rateSaidDepartment') {
        if (diagramResults[i].bureauStatistics.rateSaidDepartment != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].bureauStatistics.rateSaidDepartment),
            ),
          );
        }
      } else if (lineName == 'rateSaidFirstname') {
        if (diagramResults[i].bureauStatistics.rateSaidFirstname != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].bureauStatistics.rateSaidFirstname),
            ),
          );
        }
      } else if (lineName == 'rateSaidName') {
        if (diagramResults[i].bureauStatistics.rateSaidName != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i].bureauStatistics.rateSaidName),
            ),
          );
        }
      } else if (lineName == 'rateSaidGreeting') {
        if (diagramResults[i].bureauStatistics.rateSaidGreeting != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i].bureauStatistics.rateSaidGreeting),
            ),
          );
        }
      } else if (lineName == 'rateSaidSpecificWords') {
        if (diagramResults[i].bureauStatistics.rateSaidSpecificWords != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].bureauStatistics.rateSaidSpecificWords),
            ),
          );
        }
      } else if (lineName == 'rateReached') {
        if (diagramResults[i].bureauStatistics.rateReached != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i].bureauStatistics.rateReached),
            ),
          );
        }
      } else if (lineName == 'rateCallCompleted') {
        if (diagramResults[i].bureauStatistics.rateCallCompleted != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].bureauStatistics.rateCallCompleted),
            ),
          );
        }
      }
    }
    return result;
  }

  ///Creates single dots/data points per [lineName]
  List<FlSpot> getFlSpotsAB(
      {required int diagramLength,
      required List<Diagram> diagramResults,
      required String lineName}) {
    final List<FlSpot> result = [];
    for (int i = 0; i < diagramLength; i++) {
      if (lineName == 'rateSaidOrganizationAB') {
        if (diagramResults[i].abAndCallbackStatistics.rateSaidOrganizationAB !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateSaidOrganizationAB),
            ),
          );
        }
      } else if (lineName == 'rateSaidBureauAB') {
        if (diagramResults[i].abAndCallbackStatistics.rateSaidBureauAB != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].abAndCallbackStatistics.rateSaidBureauAB),
            ),
          );
        }
      } else if (lineName == 'rateSaidDepartmentAB') {
        if (diagramResults[i].abAndCallbackStatistics.rateSaidDepartmentAB !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateSaidDepartmentAB),
            ),
          );
        }
      } else if (lineName == 'rateSaidFirstnameAB') {
        if (diagramResults[i].abAndCallbackStatistics.rateSaidFirstnameAB !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateSaidFirstnameAB),
            ),
          );
        }
      } else if (lineName == 'rateSaidNameAB') {
        if (diagramResults[i].abAndCallbackStatistics.rateSaidNameAB != "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].abAndCallbackStatistics.rateSaidNameAB),
            ),
          );
        }
      } else if (lineName == 'rateSaidGreetingAB') {
        if (diagramResults[i].abAndCallbackStatistics.rateSaidGreetingAB !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].abAndCallbackStatistics.rateSaidGreetingAB),
            ),
          );
        }
      } else if (lineName == 'rateSaidSpecificWordsAB') {
        if (diagramResults[i].abAndCallbackStatistics.rateSaidSpecificWordsAB !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateSaidSpecificWordsAB),
            ),
          );
        }
      } else if (lineName == 'rateResponderStartedIfNotReached') {
        if (diagramResults[i]
                .abAndCallbackStatistics
                .rateResponderStartedIfNotReached !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateResponderStartedIfNotReached),
            ),
          );
        }
      } else if (lineName == 'rateResponderCorrect') {
        if (diagramResults[i].abAndCallbackStatistics.rateResponderCorrect !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateResponderCorrect),
            ),
          );
        }
      } else if (lineName == 'rateCallbackDoneNoAnswer') {
        if (diagramResults[i]
                .abAndCallbackStatistics
                .rateCallbackDoneNoAnswer !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateCallbackDoneNoAnswer),
            ),
          );
        }
      } else if (lineName == 'rateCallbackDoneResponder') {
        if (diagramResults[i]
                .abAndCallbackStatistics
                .rateCallbackDoneResponder !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateCallbackDoneResponder),
            ),
          );
        }
      } else if (lineName == 'rateCallbackDoneUnexpected') {
        if (diagramResults[i]
                .abAndCallbackStatistics
                .rateCallbackDoneUnexpected !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateCallbackDoneUnexpected),
            ),
          );
        }
      } else if (lineName == 'rateCallbackDoneOverall') {
        if (diagramResults[i].abAndCallbackStatistics.rateCallbackDoneOverall !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(diagramResults[i]
                  .abAndCallbackStatistics
                  .rateCallbackDoneOverall),
            ),
          );
        }
      } else if (lineName == 'rateCallbackInTime') {
        if (diagramResults[i].abAndCallbackStatistics.rateCallbackInTime !=
            "-") {
          result.add(
            FlSpot(
              i as double,
              double.parse(
                  diagramResults[i].abAndCallbackStatistics.rateCallbackInTime),
            ),
          );
        }
      }
    }
    return result;
  }
}
