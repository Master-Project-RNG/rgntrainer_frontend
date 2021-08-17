import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/diagram_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:intl/intl.dart';

class MyLineChart extends StatefulWidget {
  const MyLineChart({
    required this.isShowingMainData,
  });

  final bool isShowingMainData;

  @override
  _MyLineChartState createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  late User _currentUser = User.init();

  bool _isLoading = false;
  late List<Diagram> diagramResults;
  late List<int> _numericScalaTotalCalls = [];

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
    diagramResults =
        await Provider.of<BureauResultsProvider>(context, listen: false)
            .getTotalResultsWeekly(_currentUser.token);
    _numericScalaTotalCalls =
        calculateNumericScalaBureauStatistics(diagramResults);
    setState(() {
      _isLoading = false;
    });
  }

  List<int> calculateNumericScalaBureauStatistics(List<Diagram> list) {
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
          widget.isShowingMainData ? sampleData : sampleDataCallsNumeric,
          swapAnimationDuration: const Duration(milliseconds: 250),
        ),
      );
  }

  LineChartData get sampleData => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 11,
        maxY: 100,
        minY: 0,
      );

  FlTitlesData get titlesData => FlTitlesData(
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

  LineChartBarData lineChartBarRate({
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
        isCurved: false,
        colors: [color],
        barWidth: 4,
        isStrokeCapRound: false,
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

  LineChartData get sampleDataCallsNumeric => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsDataNumeric,
        minX: 0,
        maxX: 11,
        maxY: double.parse(_numericScalaTotalCalls[3].toString()),
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateSaidOrganization,
          y1: diagramResults[1].bureauStatistics.rateSaidOrganization,
          y2: diagramResults[2].bureauStatistics.rateSaidOrganization,
          y3: diagramResults[3].bureauStatistics.rateSaidOrganization,
          y4: diagramResults[4].bureauStatistics.rateSaidOrganization,
          y5: diagramResults[5].bureauStatistics.rateSaidOrganization,
          y6: diagramResults[6].bureauStatistics.rateSaidOrganization,
          y7: diagramResults[7].bureauStatistics.rateSaidOrganization,
          y8: diagramResults[8].bureauStatistics.rateSaidOrganization,
          y9: diagramResults[9].bureauStatistics.rateSaidOrganization,
          y10: diagramResults[10].bureauStatistics.rateSaidOrganization,
          y11: diagramResults[11].bureauStatistics.rateSaidOrganization,
          color: Color(0xff4af699),
        ),
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateCallCompleted,
          y1: diagramResults[1].bureauStatistics.rateCallCompleted,
          y2: diagramResults[2].bureauStatistics.rateCallCompleted,
          y3: diagramResults[3].bureauStatistics.rateCallCompleted,
          y4: diagramResults[4].bureauStatistics.rateCallCompleted,
          y5: diagramResults[5].bureauStatistics.rateCallCompleted,
          y6: diagramResults[6].bureauStatistics.rateCallCompleted,
          y7: diagramResults[7].bureauStatistics.rateCallCompleted,
          y8: diagramResults[8].bureauStatistics.rateCallCompleted,
          y9: diagramResults[9].bureauStatistics.rateCallCompleted,
          y10: diagramResults[10].bureauStatistics.rateCallCompleted,
          y11: diagramResults[11].bureauStatistics.rateCallCompleted,
          color: Color(0xff42e9f5),
        ),
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
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

  List<LineChartBarData> get lineBarsDataNumeric => [
        lineChartBarDataCalls(
          y0: diagramResults[0].bureauStatistics.totalCalls,
          y1: diagramResults[1].bureauStatistics.totalCalls,
          y2: diagramResults[2].bureauStatistics.totalCalls,
          y3: diagramResults[3].bureauStatistics.totalCalls,
          y4: diagramResults[4].bureauStatistics.totalCalls,
          y5: diagramResults[5].bureauStatistics.totalCalls,
          y6: diagramResults[6].bureauStatistics.totalCalls,
          y7: diagramResults[7].bureauStatistics.totalCalls,
          y8: diagramResults[8].bureauStatistics.totalCalls,
          y9: diagramResults[9].bureauStatistics.totalCalls,
          y10: diagramResults[10].bureauStatistics.totalCalls,
          y11: diagramResults[11].bureauStatistics.totalCalls,
          color: Color(0xff4af699),
        ),
        lineChartBarDataCalls(
          y0: diagramResults[0].bureauStatistics.totalCallsReached,
          y1: diagramResults[1].bureauStatistics.totalCallsReached,
          y2: diagramResults[2].bureauStatistics.totalCallsReached,
          y3: diagramResults[3].bureauStatistics.totalCallsReached,
          y4: diagramResults[4].bureauStatistics.totalCallsReached,
          y5: diagramResults[5].bureauStatistics.totalCallsReached,
          y6: diagramResults[6].bureauStatistics.totalCallsReached,
          y7: diagramResults[7].bureauStatistics.totalCallsReached,
          y8: diagramResults[8].bureauStatistics.totalCallsReached,
          y9: diagramResults[9].bureauStatistics.totalCallsReached,
          y10: diagramResults[10].bureauStatistics.totalCallsReached,
          y11: diagramResults[11].bureauStatistics.totalCallsReached,
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
              return formatter.format(diagramResults[0].date).toString();
            case 2:
              return formatter.format(diagramResults[2].date).toString();
            case 4:
              return formatter.format(diagramResults[4].date).toString();
            case 6:
              return formatter.format(diagramResults[6].date).toString();
            case 8:
              return formatter.format(diagramResults[8].date).toString();
            case 10:
              return formatter.format(diagramResults[10].date).toString();
          }
          return '';
        },
      );

  FlGridData get gridData => FlGridData(
        show: true,
        horizontalInterval: 10,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.black, width: 2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
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

class LineChartSample1 extends StatefulWidget {
  final String title;
  LineChartSample1({required this.title});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
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
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
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
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: MyLineChart(
                      isShowingMainData: isShowingMainData,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.black.withOpacity(isShowingMainData ? 1.0 : 0.5),
              ),
              onPressed: () {
                setState(() {
                  isShowingMainData = !isShowingMainData;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
