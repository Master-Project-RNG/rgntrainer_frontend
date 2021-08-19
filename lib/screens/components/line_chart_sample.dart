import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';
import 'package:rgntrainer_frontend/models/diagram_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/screens/components/line_chart.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';

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
  int selectedQueryType = 0;
  late List<String> _getBureausNames = [];
  late User _currentUser;
  bool _isLoading = false;
  late List<Diagram> diagramResults;

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    isShowingMainData = true;
    getAsyncData();
  }

  getAsyncData() async {
    setState(() {
      _isLoading = true;
    });
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
      _isLoading = false;
    });
  }

  updateAsyncData() async {
    setState(() {
      _isLoading = true;
    });
    diagramResults =
        await Provider.of<BureauResultsProvider>(context, listen: false)
            .getTotalResultsWeekly(
                _currentUser.token, _getBureausNames[selectedQueryType]);
    setState(() {
      _isLoading = false;
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : PopupMenuButton(
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
                        child: SizedBox(
                          width: 300,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
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
                child: _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : MyLineChart(
                        isShowingMainData: isShowingMainData,
                        selectedQueryType: selectedQueryType,
                        diagramResults: diagramResults,
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
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 4,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        maxCrossAxisExtent: 200,
                      ),
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics
                                  .bureauStatisticsDiagramColors["totalCalls"]!,
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                              BureauStatistics.bureauStatisticsDiagramColors[
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
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _getBureausNames[i],
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          value: i,
        ),
      );
    }
    return result;
  }
}
