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
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidOrganization"]!,
        ),
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateSaidBureau,
          y1: diagramResults[1].bureauStatistics.rateSaidBureau,
          y2: diagramResults[2].bureauStatistics.rateSaidBureau,
          y3: diagramResults[3].bureauStatistics.rateSaidBureau,
          y4: diagramResults[4].bureauStatistics.rateSaidBureau,
          y5: diagramResults[5].bureauStatistics.rateSaidBureau,
          y6: diagramResults[6].bureauStatistics.rateSaidBureau,
          y7: diagramResults[7].bureauStatistics.rateSaidBureau,
          y8: diagramResults[8].bureauStatistics.rateSaidBureau,
          y9: diagramResults[9].bureauStatistics.rateSaidBureau,
          y10: diagramResults[10].bureauStatistics.rateSaidBureau,
          y11: diagramResults[11].bureauStatistics.rateSaidBureau,
          color:
              BureauStatistics.bureauStatisticsDiagramColors["rateSaidBureau"]!,
        ),
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateSaidDepartment,
          y1: diagramResults[1].bureauStatistics.rateSaidDepartment,
          y2: diagramResults[2].bureauStatistics.rateSaidDepartment,
          y3: diagramResults[3].bureauStatistics.rateSaidDepartment,
          y4: diagramResults[4].bureauStatistics.rateSaidDepartment,
          y5: diagramResults[5].bureauStatistics.rateSaidDepartment,
          y6: diagramResults[6].bureauStatistics.rateSaidDepartment,
          y7: diagramResults[7].bureauStatistics.rateSaidDepartment,
          y8: diagramResults[8].bureauStatistics.rateSaidDepartment,
          y9: diagramResults[9].bureauStatistics.rateSaidDepartment,
          y10: diagramResults[10].bureauStatistics.rateSaidDepartment,
          y11: diagramResults[11].bureauStatistics.rateSaidDepartment,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidDepartment"]!,
        ),
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateSaidFirstname,
          y1: diagramResults[1].bureauStatistics.rateSaidFirstname,
          y2: diagramResults[2].bureauStatistics.rateSaidFirstname,
          y3: diagramResults[3].bureauStatistics.rateSaidFirstname,
          y4: diagramResults[4].bureauStatistics.rateSaidFirstname,
          y5: diagramResults[5].bureauStatistics.rateSaidFirstname,
          y6: diagramResults[6].bureauStatistics.rateSaidFirstname,
          y7: diagramResults[7].bureauStatistics.rateSaidFirstname,
          y8: diagramResults[8].bureauStatistics.rateSaidFirstname,
          y9: diagramResults[9].bureauStatistics.rateSaidFirstname,
          y10: diagramResults[10].bureauStatistics.rateSaidFirstname,
          y11: diagramResults[11].bureauStatistics.rateSaidFirstname,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidFirstname"]!,
        ),
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateSaidName,
          y1: diagramResults[1].bureauStatistics.rateSaidName,
          y2: diagramResults[2].bureauStatistics.rateSaidName,
          y3: diagramResults[3].bureauStatistics.rateSaidName,
          y4: diagramResults[4].bureauStatistics.rateSaidName,
          y5: diagramResults[5].bureauStatistics.rateSaidName,
          y6: diagramResults[6].bureauStatistics.rateSaidName,
          y7: diagramResults[7].bureauStatistics.rateSaidName,
          y8: diagramResults[8].bureauStatistics.rateSaidName,
          y9: diagramResults[9].bureauStatistics.rateSaidName,
          y10: diagramResults[10].bureauStatistics.rateSaidName,
          y11: diagramResults[11].bureauStatistics.rateSaidName,
          color:
              BureauStatistics.bureauStatisticsDiagramColors["rateSaidName"]!,
        ),
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateSaidGreeting,
          y1: diagramResults[1].bureauStatistics.rateSaidGreeting,
          y2: diagramResults[2].bureauStatistics.rateSaidGreeting,
          y3: diagramResults[3].bureauStatistics.rateSaidGreeting,
          y4: diagramResults[4].bureauStatistics.rateSaidGreeting,
          y5: diagramResults[5].bureauStatistics.rateSaidGreeting,
          y6: diagramResults[6].bureauStatistics.rateSaidGreeting,
          y7: diagramResults[7].bureauStatistics.rateSaidGreeting,
          y8: diagramResults[8].bureauStatistics.rateSaidGreeting,
          y9: diagramResults[9].bureauStatistics.rateSaidGreeting,
          y10: diagramResults[10].bureauStatistics.rateSaidGreeting,
          y11: diagramResults[11].bureauStatistics.rateSaidGreeting,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidGreeting"]!,
        ),
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateSaidSpecificWords,
          y1: diagramResults[1].bureauStatistics.rateSaidSpecificWords,
          y2: diagramResults[2].bureauStatistics.rateSaidSpecificWords,
          y3: diagramResults[3].bureauStatistics.rateSaidSpecificWords,
          y4: diagramResults[4].bureauStatistics.rateSaidSpecificWords,
          y5: diagramResults[5].bureauStatistics.rateSaidSpecificWords,
          y6: diagramResults[6].bureauStatistics.rateSaidSpecificWords,
          y7: diagramResults[7].bureauStatistics.rateSaidSpecificWords,
          y8: diagramResults[8].bureauStatistics.rateSaidSpecificWords,
          y9: diagramResults[9].bureauStatistics.rateSaidSpecificWords,
          y10: diagramResults[10].bureauStatistics.rateSaidSpecificWords,
          y11: diagramResults[11].bureauStatistics.rateSaidSpecificWords,
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateSaidSpecificWords"]!,
        ),
        lineChartBarRate(
          y0: diagramResults[0].bureauStatistics.rateReached,
          y1: diagramResults[1].bureauStatistics.rateReached,
          y2: diagramResults[2].bureauStatistics.rateReached,
          y3: diagramResults[3].bureauStatistics.rateReached,
          y4: diagramResults[4].bureauStatistics.rateReached,
          y5: diagramResults[5].bureauStatistics.rateReached,
          y6: diagramResults[6].bureauStatistics.rateReached,
          y7: diagramResults[7].bureauStatistics.rateReached,
          y8: diagramResults[8].bureauStatistics.rateReached,
          y9: diagramResults[9].bureauStatistics.rateReached,
          y10: diagramResults[10].bureauStatistics.rateReached,
          y11: diagramResults[11].bureauStatistics.rateReached,
          color: BureauStatistics.bureauStatisticsDiagramColors["rateReached"]!,
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
          color: BureauStatistics
              .bureauStatisticsDiagramColors["rateCallCompleted"]!,
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
  LineChartSample1({
    required this.title,
  });

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
                isShowingMainData
                    ? Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: 200,
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 4,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            maxCrossAxisExtent: 200,
                          ),
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateSaidOrganization"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateSaidOrganization"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateSaidBureau"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateSaidBureau"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateSaidDepartment"]!, //cyan
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateSaidDepartment"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateSaidFirstname"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateSaidFirstname"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateSaidName"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateSaidName"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateSaidGreeting"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateSaidGreeting"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateSaidSpecificWords"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateSaidSpecificWords"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateReached"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateReached"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "rateCallCompleted"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "rateCallCompleted"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: 200,
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 4,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            maxCrossAxisExtent: 200,
                          ),
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "totalCalls"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "totalCalls"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  BureauStatistics
                                          .bureauStatisticsDiagramColors[
                                      "totalCallsReached"]!,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                BureauStatistics
                                        .bureauStatisticsTranslationToGerman[
                                    "totalCallsReached"]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
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
