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
        gridData: gridData,
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
        gridData: gridData,
        titlesData: titlesDataNumericValues,
        borderData: borderData,
        lineBarsData: lineBarsDataNumeric,
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
  FlTitlesData get titlesDataNumericValues => FlTitlesData(
        bottomTitles: bottomTitles,
        leftTitles: leftTitles(
          getTitles: (value) {
            if (value == _numericScalaTotalCalls[0]) {
              return _numericScalaTotalCalls[0].toString();
            }
            if (value == _numericScalaTotalCalls[1]) {
              return _numericScalaTotalCalls[1].toString();
            }
            if (value == _numericScalaTotalCalls[2]) {
              return _numericScalaTotalCalls[2].toString();
            }
            if (value == _numericScalaTotalCalls[3]) {
              return _numericScalaTotalCalls[3].toString();
            }
            /*switch (value.toInt()) {
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
            }*/
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
          switch (value.toInt()) {
            case 0:
              return formatter.format(widget.diagramResults[0].date).toString();
            case 2:
              return formatter.format(widget.diagramResults[2].date).toString();
            case 4:
              return formatter.format(widget.diagramResults[4].date).toString();
            /*   case 6:
              return formatter.format(diagramResults[6].date).toString();
            case 8:
              return formatter.format(diagramResults[8].date).toString();
            case 10:
              return formatter.format(diagramResults[10].date).toString();*/
          }
          return '';
        },
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
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateSaidOrganization"]!,
        lineName: "rateSaidOrganization",
      ),
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color:
            BureauStatistics.bureauStatisticsDiagramColors["rateSaidBureau"]!,
        lineName: "rateSaidBureau",
      ),
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateSaidDepartment"]!,
        lineName: "rateSaidDepartment",
      ),
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateSaidFirstname"]!,
        lineName: "rateSaidFirstname",
      ),
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics.bureauStatisticsDiagramColors["rateSaidName"]!,
        lineName: "rateSaidName",
      ),
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color:
            BureauStatistics.bureauStatisticsDiagramColors["rateSaidGreeting"]!,
        lineName: "rateSaidGreeting",
      ),
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateSaidSpecificWords"]!,
        lineName: "rateSaidSpecificWords",
      ),
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics.bureauStatisticsDiagramColors["rateReached"]!,
        lineName: "rateReached",
      ),
      lineChartBarRateValues(
        diagramLength: diagramLength,
        diagramResults: widget.diagramResults,
        color: BureauStatistics
            .bureauStatisticsDiagramColors["rateCallCompleted"]!,
        lineName: "rateCallCompleted",
      ),
    ];
  }

  LineChartBarData lineChartBarRateValues({
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
        spots: getFlSpotsRate(
          diagramLength: diagramLength,
          diagramResults: diagramResults,
          lineName: lineName,
        ),
      );

  List<FlSpot> getFlSpotsRate(
      {required int diagramLength,
      required List<Diagram> diagramResults,
      required String lineName}) {
    final List<FlSpot> result = [];
    for (int i = 0; i < diagramLength; i++) {
      if (lineName == 'rateSaidOrganization') {
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

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  List<LineChartBarData> get lineBarsDataNumeric => [
        lineChartBarDataCalls(
          y0: widget.diagramResults[0].bureauStatistics.totalCalls,
          y1: widget.diagramResults[1].bureauStatistics.totalCalls,
          y2: widget.diagramResults[2].bureauStatistics.totalCalls,
          y3: widget.diagramResults[3].bureauStatistics.totalCalls,
          y4: widget.diagramResults[4].bureauStatistics.totalCalls,
          y5: widget.diagramResults[5].bureauStatistics.totalCalls,
          y6: widget.diagramResults[6].bureauStatistics.totalCalls,
          y7: widget.diagramResults[7].bureauStatistics.totalCalls,
          y8: widget.diagramResults[8].bureauStatistics.totalCalls,
          y9: widget.diagramResults[9].bureauStatistics.totalCalls,
          y10: widget.diagramResults[10].bureauStatistics.totalCalls,
          y11: widget.diagramResults[11].bureauStatistics.totalCalls,
          color: Color(0xff4af699),
        ),
        lineChartBarDataCalls(
          y0: widget.diagramResults[0].bureauStatistics.totalCallsReached,
          y1: widget.diagramResults[1].bureauStatistics.totalCallsReached,
          y2: widget.diagramResults[2].bureauStatistics.totalCallsReached,
          y3: widget.diagramResults[3].bureauStatistics.totalCallsReached,
          y4: widget.diagramResults[4].bureauStatistics.totalCallsReached,
          y5: widget.diagramResults[5].bureauStatistics.totalCallsReached,
          y6: widget.diagramResults[6].bureauStatistics.totalCallsReached,
          y7: widget.diagramResults[7].bureauStatistics.totalCallsReached,
          y8: widget.diagramResults[8].bureauStatistics.totalCallsReached,
          y9: widget.diagramResults[9].bureauStatistics.totalCallsReached,
          y10: widget.diagramResults[10].bureauStatistics.totalCallsReached,
          y11: widget.diagramResults[11].bureauStatistics.totalCallsReached,
          color: Color(0xff42e9f5),
        ),
      ];

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

  FlGridData get gridData => FlGridData(
        show: true,
        horizontalInterval: 10,
      );

  LineChartBarData lineChartBarDataCalls({
    required String y0,
    required String y1,
    required String y2,
    required String y3,
    required String y4,
    required String y5,
    required String y6,
    required String y7,
    required String y8,
    required String y9,
    required String y10,
    required String y11,
    required Color color,
  }) =>
      LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        colors: [color],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          if (y0 != "-")
            FlSpot(
              0,
              double.parse(y0),
            ),
          if (y1 != "-")
            FlSpot(
              1,
              double.parse(y1),
            ),
          if (y2 != "-")
            FlSpot(
              2,
              double.parse(y2),
            ),
          if (y3 != "-")
            FlSpot(
              3,
              double.parse(y3),
            ),
          if (y4 != "-")
            FlSpot(
              4,
              double.parse(y4),
            ),
          if (y5 != "-")
            FlSpot(
              5,
              double.parse(y5),
            ),
          if (y6 != "-")
            FlSpot(
              6,
              double.parse(y6),
            ),
          if (y7 != "-")
            FlSpot(
              7,
              double.parse(y7),
            ),
          if (y8 != "-")
            FlSpot(
              8,
              double.parse(y8),
            ),
          if (y9 != "-")
            FlSpot(
              9,
              double.parse(y9),
            ),
          if (y10 != "-")
            FlSpot(
              10,
              double.parse(y10),
            ),
          if (y11 != "-")
            FlSpot(
              11,
              double.parse(y11),
            ),
        ],
      );
}
