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

  const MyLineChart(
      {required this.isShowingMainData,
      required this.selectedQueryType,
      required this.diagramResults});

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
        lineBarsData: lineBarsDataRateValues,
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
  List<LineChartBarData> get lineBarsDataRateValues {
    int diagramLength = widget.diagramResults.length;
    return [
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateSaidOrganization"]!,
        lineName: "rateSaidOrganization",
      ),
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color:
            BureauStatistics.bureauStatisticsDiagramColors["rateSaidBureau"]!,
        lineName: "rateSaidBureau",
      ),
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateSaidDepartment"]!,
        lineName: "rateSaidDepartment",
      ),
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateSaidFirstname"]!,
        lineName: "rateSaidFirstname",
      ),
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics.bureauStatisticsDiagramColors["rateSaidName"]!,
        lineName: "rateSaidName",
      ),
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color:
            BureauStatistics.bureauStatisticsDiagramColors["rateSaidGreeting"]!,
        lineName: "rateSaidGreeting",
      ),
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateSaidSpecificWords"]!,
        lineName: "rateSaidSpecificWords",
      ),
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics.bureauStatisticsDiagramColors["rateReached"]!,
        lineName: "rateReached",
      ),
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
  List<LineChartBarData> get lineBarsDataNumericValues {
    int diagramLength = widget.diagramResults.length;
    return [
      lineChartBar(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics.bureauStatisticsDiagramColors["totalCalls"]!,
        lineName: "totalCalls",
      ),
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
        spots: getFlSpots(
          diagramLength: diagramLength,
          diagramResults: diagramResults,
          lineName: lineName,
        ),
      );

  ///Creates single dots/data points per [lineName]
  List<FlSpot> getFlSpots(
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
}
