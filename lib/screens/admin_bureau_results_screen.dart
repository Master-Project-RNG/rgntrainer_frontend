import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/provider/results_download_provider.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/widgets/ui/calendar_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/navbar_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/title_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/date_symbol_data_local.dart';

class AdminResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminResultsCard();
  }
}

class AdminResultsCard extends StatefulWidget {
  const AdminResultsCard({
    Key? key,
  }) : super(key: key);

  @override
  _AdminCardState createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminResultsCard> {
  late User _currentUser = User.init();
  var _isLoading = false;
  late List<BureauResults> bureauResults;
  final List<String> queryType = ["Standart", "Anrufbeantworter"];
  int selectedQueryType = 0;

  int? sortColumnIndex; //Reflects the column that is currently sorted!
  bool isAscending = false;

  List<bool> showColumns = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    _fetchTotalUserResults();
    print(_currentUser.token);
    initializeDateFormatting(); //set CalendarWidget language to German
  }

  //Fetch all Listings
  Future _fetchTotalUserResults() async {
    setState(() {
      _isLoading = true;
    });
    bureauResults =
        await Provider.of<BureauResultsProvider>(context, listen: false)
            .getBureauResults(_currentUser.token);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser.token == null || _currentUser.usertype != "admin") {
      return NoTokenScreen();
    } else {
      final _myBureauResultsProvider = context.watch<BureauResultsProvider>();
      final _myDownloadResultsProvider =
          context.watch<DownloadResultsProvider>();
      return Row(
        children: [
          NavBarWidget(_currentUser),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 65,
                titleSpacing:
                    0, //So that the title start right away at the left side
                title: CalendarWidget(),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.vxNav.push(
                        Uri.parse(MyRoutes.adminProfilRoute),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      AuthProvider().logout(_currentUser.token);
                      context.vxNav.push(
                        Uri.parse(MyRoutes.loginRoute),
                      );
                    },
                  )
                ],
                automaticallyImplyLeading: false,
              ),
              body: Column(
                children: [
                  TitleWidget("Abfragen"),
                  Container(
                    padding: EdgeInsets.only(left: 50, top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Resultate der Büros für ${_currentUser.username}",
                          style: const TextStyle(fontSize: 34),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: PopupMenuButton(
                            onSelected: (result) {
                              if (_isLoading == true) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Geduld bitte'),
                                    content: Text(
                                        "Die Einträge werden noch geladen."),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('Schliessen!'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                if (result == 0) {
                                  setState(() {
                                    this.selectedQueryType = 0;
                                  });
                                } else if (result == 1) {
                                  setState(() {
                                    this.selectedQueryType = 1;
                                  });
                                }
                              }
                            },
                            itemBuilder: (context) {
                              return List.generate(
                                2,
                                (index) {
                                  return PopupMenuItem(
                                    value: index,
                                    child: Row(
                                      children: [
                                        index == 0
                                            ? Text("Standart")
                                            : Text("Anrufbeantworter"),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: SizedBox(
                              width: 200,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                alignment: Alignment.center,
                                child: Text(
                                  'Abfragetyp',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //STANDART!!!!
                        Container(
                          alignment: Alignment.centerLeft,
                          child: PopupMenuButton(
                            itemBuilder: (context) {
                              return List.generate(
                                columnsStandart.length,
                                (index) {
                                  return PopupMenuItem(
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState2) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            (isVisible(index, showColumns))
                                                ? IconButton(
                                                    onPressed: () {
                                                      setState2(() {
                                                        changeVisibilty(
                                                            index, showColumns);
                                                      });
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      setState2(() {
                                                        changeVisibilty(
                                                            index, showColumns);
                                                      });
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.add_circle,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                            Text(columnsStandart
                                                .elementAt(index)),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: SizedBox(
                              width: 200,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                alignment: Alignment.center,
                                child: Text(
                                  'Spalten ein-/ausblenden',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 50),
                          child: PopupMenuButton(
                            onSelected: (result) {
                              if (_isLoading == true) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Geduld bitte'),
                                    content: Text(
                                        "Die Einträge werden noch geladen."),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('Schliessen!'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                if (result == 0) {
                                  _myDownloadResultsProvider
                                      .getExcelResults(_currentUser.token);
                                } else if (result == 1) {
                                  _myDownloadResultsProvider.getJsonResults(
                                      _currentUser.token,
                                      _myBureauResultsProvider.bureauResults);
                                }
                              }
                            },
                            itemBuilder: (context) {
                              return List.generate(
                                2,
                                (index) {
                                  return PopupMenuItem(
                                    value: index,
                                    child: Row(
                                      children: [
                                        index == 0
                                            ? Text("Excel")
                                            : Text("Json"),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: SizedBox(
                              width: 200,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                                alignment: Alignment.center,
                                child: Text(
                                  'Exportieren',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: this.selectedQueryType == 0
                                ? bureauResultsDataNormal(
                                    _myBureauResultsProvider)
                                : bureauResultsDataNormal(
                                    _myBureauResultsProvider),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  final columnsStandart = [
    'Büro',
    'Totale Anrufe',
    'Anrufe beantwortet',
    'Organisation gesagt',
    "Büro gesagt",
    "Abteilung gesagt",
    "Vorname gesagt",
    "Nachname gesagt",
    "Begrüssung gesagt",
    "Spezifische Wörter gesagt",
    "Erreicht",
    "Anruf komplett",
    "Durchschnittliche Klingelzeit", //13 Spalten (12 index)
  ];

  final columnsAB = [
    'Büro',
    "Organisation gesagt",
    "Büro gesagt",
    "Abteilung gesagt",
    "Vorname gesagt",
    "Nachname gesagt",
    "Begrüssung gesagt",
    "Spezifische Wörter gesagt",
    "AB aufgeschaltet (falls nicht erreicht)",
    "AB Nachricht korrekt",
    "rateCallbackDoneNoAnswer",
    "Kein AB geschaltet - Rückrufrate",
    "AB geschaltet - Rückrufrate",
    "Unerwarteter Rückruf",
    "Rückrufrate gesamt",
    "Rückruf innerhalb der Zeit", //16 Spalten (15 index)
  ];

  Widget bureauResultsDataNormal(
      BureauResultsProvider _myBureauResultsProvider) {
    if (_isLoading == true) {
      return CircularProgressIndicator();
    } else
      return DataTable(
        dataRowHeight: 25,
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columnsStandart, showColumns),
        rows: getRowsStandart(
            _myBureauResultsProvider.bureauResults, showColumns),
      );
  }

  void changeVisibilty(int index, List<bool> list) {
    list[index] = list.elementAt(index).toggle();
    sortColumnIndex = null;
  }

  bool isVisible(int index, List<bool> list) {
    bool result;
    list.elementAt(index) == true ? result = true : result = false;
    return result;
  }

  List<DataColumn> getColumns(List<String> columns, List<bool> showColumns) {
    List<DataColumn> dataColumnResult = [];
    for (int i = 0; i < columns.length; i++) {
      if (showColumns[i] == true) {
        dataColumnResult.add(
          DataColumn(
            label: Text(columns[i]),
            onSort: onSort,
          ),
        );
      }
    }
    return dataColumnResult;
  }

  List<DataRow> getRowsStandart(
      List<BureauResults> bureauResults, List<bool> showColumns) {
    List<DataRow> dataRowResult = [];
    for (int i = 0; i < bureauResults.length; i++) {
      final cells = [];
      if (showColumns[0]) cells.add(bureauResults[i].bureau.toString());
      if (showColumns[1])
        cells.add(bureauResults[i].bureauStatistics.totalCalls.toString());
      if (showColumns[2])
        cells.add(
            bureauResults[i].bureauStatistics.totalCallsReached.toString());
      if (showColumns[3])
        cells.add(bureauResults[i].bureauStatistics.rateSaidOrganization + "%");
      if (showColumns[4])
        cells.add(bureauResults[i].bureauStatistics.rateSaidBureau + "%");
      if (showColumns[5])
        cells.add(bureauResults[i].bureauStatistics.rateSaidDepartment + "%");
      if (showColumns[6])
        cells.add(bureauResults[i].bureauStatistics.rateSaidFirstname + "%");
      if (showColumns[7])
        cells.add(bureauResults[i].bureauStatistics.rateSaidName + "%");
      if (showColumns[8])
        cells.add(bureauResults[i].bureauStatistics.rateSaidGreeting + "%");
      if (showColumns[9])
        cells
            .add(bureauResults[i].bureauStatistics.rateSaidSpecificWords + "%");
      if (showColumns[10])
        cells.add(bureauResults[i].bureauStatistics.rateReached + "%");
      if (showColumns[11])
        cells.add(bureauResults[i].bureauStatistics.rateCallCompleted + "%");

      if (showColumns[12])
        cells.add(bureauResults[i].bureauStatistics.meanRingingTime != "-"
            ? double.parse(bureauResults[i].bureauStatistics.meanRingingTime)
                    .toStringAsFixed(2) +
                " Sekunden"
            : "-");
      dataRowResult.add(DataRow(cells: getCellsStandart(cells)));
    }
    return dataRowResult;
  }

  List<DataRow> getRowsAB(
      List<BureauResults> bureauResults, List<bool> showColumns) {
    List<DataRow> dataRowResult = [];
    for (int i = 0; i < bureauResults.length; i++) {
      final cells = [];
      if (showColumns[12])
        cells.add(bureauResults[i]
                .abAndCallbackStatistics
                .rateResponderStartedIfNotReached +
            "%");
      if (showColumns[13])
        cells.add(
            bureauResults[i].abAndCallbackStatistics.rateResponderCorrect +
                "%");
      if (showColumns[14])
        cells.add(
            bureauResults[i].abAndCallbackStatistics.rateCallbackDoneNoAnswer +
                "%");
      if (showColumns[15])
        cells.add(
            bureauResults[i].abAndCallbackStatistics.rateCallbackDoneResponder +
                "%");
      if (showColumns[16])
        cells.add(
            bureauResults[i].abAndCallbackStatistics.rateCallbackInTime + "%");
    }

    return dataRowResult;
  }

  int getHiddenCount(int index, List<bool> _showColumns) {
    int result = 0;
    for (int i = 0; i < index; i++) {
      if (_showColumns[i] == false) {
        result++;
      }
    }
    return result;
  }

  List<DataCell> getCellsStandart(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == (0 - getHiddenCount(0, showColumns)) &&
        showColumns[0] == true) {
      bureauResults.sort((user1, user2) =>
          compareString(ascending, user1.bureau, user2.bureau));
    } else if (columnIndex == (1 - getHiddenCount(1, showColumns)) &&
        showColumns[1] == true) {
      bureauResults.sort((user1, user2) => compareInteger(
            ascending,
            int.parse(user1.bureauStatistics.totalCalls),
            int.parse(user2.bureauStatistics.totalCalls),
          ));
    } else if (columnIndex == (2 - getHiddenCount(2, showColumns)) &&
        showColumns[2] == true) {
      bureauResults.sort((user1, user2) => compareInteger(
            ascending,
            int.parse(user1.bureauStatistics.totalCallsReached),
            int.parse(user2.bureauStatistics.totalCallsReached),
          ));
    } else if (columnIndex == (3 - getHiddenCount(3, showColumns)) &&
        showColumns[3] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateSaidOrganization != "-"
                ? double.parse(user1.bureauStatistics.rateSaidOrganization)
                : -1.0,
            user2.bureauStatistics.rateSaidOrganization != "-"
                ? double.parse(user2.bureauStatistics.rateSaidOrganization)
                : -1.0,
          ));
    } else if (columnIndex == (4 - getHiddenCount(4, showColumns)) &&
        showColumns[4] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateSaidBureau != "-"
                ? double.parse(user1.bureauStatistics.rateSaidBureau)
                : -1.0,
            user2.bureauStatistics.rateSaidBureau != "-"
                ? double.parse(user2.bureauStatistics.rateSaidBureau)
                : -1.0,
          ));
    } else if (columnIndex == (5 - getHiddenCount(5, showColumns)) &&
        showColumns[5] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateSaidDepartment != "-"
                ? double.parse(user1.bureauStatistics.rateSaidDepartment)
                : -1.0,
            user2.bureauStatistics.rateSaidDepartment != "-"
                ? double.parse(user2.bureauStatistics.rateSaidDepartment)
                : -1.0,
          ));
    } else if (columnIndex == (6 - getHiddenCount(6, showColumns)) &&
        showColumns[6] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateSaidFirstname != "-"
                ? double.parse(user1.bureauStatistics.rateSaidFirstname)
                : -1.0,
            user2.bureauStatistics.rateSaidFirstname != "-"
                ? double.parse(user2.bureauStatistics.rateSaidFirstname)
                : -1.0,
          ));
    } else if (columnIndex == (7 - getHiddenCount(7, showColumns)) &&
        showColumns[7] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateSaidName != "-"
                ? double.parse(user1.bureauStatistics.rateSaidName)
                : -1.0,
            user2.bureauStatistics.rateSaidName != "-"
                ? double.parse(user2.bureauStatistics.rateSaidName)
                : -1.0,
          ));
    } else if (columnIndex == (8 - getHiddenCount(8, showColumns)) &&
        showColumns[8] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateSaidGreeting != "-"
                ? double.parse(user1.bureauStatistics.rateSaidGreeting)
                : -1.0,
            user2.bureauStatistics.rateSaidGreeting != "-"
                ? double.parse(user2.bureauStatistics.rateSaidGreeting)
                : -1.0,
          ));
    } else if (columnIndex == (9 - getHiddenCount(9, showColumns)) &&
        showColumns[9] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateSaidSpecificWords != "-"
                ? double.parse(user1.bureauStatistics.rateSaidSpecificWords)
                : -1.0,
            user2.bureauStatistics.rateSaidSpecificWords != "-"
                ? double.parse(user2.bureauStatistics.rateSaidSpecificWords)
                : -1.0,
          ));
    } else if (columnIndex == (10 - getHiddenCount(10, showColumns)) &&
        showColumns[10] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateReached != "-"
                ? double.parse(user1.bureauStatistics.rateReached)
                : -1.0,
            user2.bureauStatistics.rateReached != "-"
                ? double.parse(user2.bureauStatistics.rateReached)
                : -1.0,
          ));
    } else if (columnIndex == (11 - getHiddenCount(11, showColumns)) &&
        showColumns[11] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.rateCallCompleted != "-"
                ? double.parse(user1.bureauStatistics.rateCallCompleted)
                : -1.0,
            user2.bureauStatistics.rateCallCompleted != "-"
                ? double.parse(user2.bureauStatistics.rateCallCompleted)
                : -1.0,
          ));
    } /* else if (columnIndex == 12) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateResponderStartedIfNotReached != "-"
                ? double.parse(user1.rateResponderStartedIfNotReached)
                : -1.0,
            user2.rateResponderStartedIfNotReached != "-"
                ? double.parse(user2.rateResponderStartedIfNotReached)
                : -1.0,
          ));
    } else if (columnIndex == 13) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateResponderCorrect != "-"
                ? double.parse(user1.rateResponderCorrect)
                : -1.0,
            user2.rateResponderCorrect != "-"
                ? double.parse(user2.rateResponderCorrect)
                : -1.0,
          ));
    } else if (columnIndex == 14) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateCallbackDoneNoAnswer != "-"
                ? double.parse(user1.rateCallbackDoneNoAnswer)
                : -1.0,
            user2.rateCallbackDoneNoAnswer != "-"
                ? double.parse(user2.rateCallbackDoneNoAnswer)
                : -1.0,
          ));
    } else if (columnIndex == 14) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateCallbackDoneResponder != "-"
                ? double.parse(user1.rateCallbackDoneResponder)
                : -1.0,
            user2.rateCallbackDoneResponder != "-"
                ? double.parse(user2.rateCallbackDoneResponder)
                : -1.0,
          ));
    } else if (columnIndex == 15) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateCallbackInTime != "-"
                ? double.parse(user1.rateCallbackInTime)
                : -1.0,
            user2.rateCallbackInTime != "-"
                ? double.parse(user2.rateCallbackInTime)
                : -1.0,
          ));
    } */
    else if (columnIndex == (12 - getHiddenCount(12, showColumns)) &&
        showColumns[12] == true) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.bureauStatistics.meanRingingTime != "-"
                ? double.parse(user1.bureauStatistics.meanRingingTime)
                : -1.0,
            user2.bureauStatistics.meanRingingTime != "-"
                ? double.parse(user2.bureauStatistics.meanRingingTime)
                : -1.0,
          ));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }
}

int compareString(bool ascending, String value1, String value2) =>
    ascending ? value1.compareTo(value2) : value2.compareTo(value1);

int compareInteger(bool ascending, int value1, int value2) =>
    ascending ? value1.compareTo(value2) : value2.compareTo(value1);

int compareDouble(bool ascending, double value1, double value2) {
  return ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

class AbfrageButton extends StatefulWidget {
  final bool isLoading;
  AbfrageButton(this.isLoading);

  @override
  _AbfrageButtonState createState() => _AbfrageButtonState();
}

class _AbfrageButtonState extends State<AbfrageButton> {
  int selectedQueryType = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 50),
      child: PopupMenuButton(
        onSelected: (result) {
          if (widget.isLoading == true) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Geduld bitte'),
                content: Text("Die Einträge werden noch geladen."),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Schliessen!'),
                  ),
                ],
              ),
            );
          } else {
            if (result == 0) {
              setState(() {
                selectedQueryType = 0;
              });
            } else if (result == 1) {
              setState(() {
                selectedQueryType = 1;
              });
            }
          }
        },
        itemBuilder: (context) {
          return List.generate(
            2,
            (index) {
              return PopupMenuItem(
                value: index,
                child: Row(
                  children: [
                    index == 0 ? Text("Standart") : Text("Anrufbeantworter"),
                  ],
                ),
              );
            },
          );
        },
        child: SizedBox(
          width: 200,
          height: 30,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(3))),
            alignment: Alignment.center,
            child: Text(
              'Abfragetyp',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}





/*
class BureauResultDataSource extends DataTableSource {
  List<BureauResults> _bureauResults;
  int _selectedCount = 0;

  BureauResultDataSource(List<BureauResults> this._bureauResults);

  @override
  DataRow? getRow(int index) {
    final format = NumberFormat.decimalPercentPattern(
      decimalDigits: 0,
    );
    assert(index >= 0);
    if (index >= _bureauResults.length) return null!;
    final bureauResult = _bureauResults[index];
    return DataRow.byIndex(
      index: index,
      cells: getRows(bureauResult),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _bureauResults.length;

  @override
  int get selectedRowCount => _selectedCount;

  List<DataCell> getRows(BureauResults data) {
    var cells = [
      data.bureau.toString(),
      data.totalCalls.toString(),
      data.totalCallsReached.toString(),
      data.rateSaidOrganization + "%",
      data.rateSaidBureau + "%",
      data.rateSaidDepartment + "%",
      data.rateSaidFirstname + "%",
      data.rateSaidName + "%",
      data.rateSaidGreeting + "%",
      data.rateSaidSpecificWords + "%",
      data.rateReached + "%",
      data.rateCallCompleted + "%",
      data.rateResponderStartedIfNotReached + "%",
      data.rateResponderCorrect + "%",
      data.rateCallbackDone + "%",
      data.rateCallbackInTime + "%",
      data.meanRingingTime + "Sekunden",
    ];
    return getCells(cells);
  }

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
}
*/
