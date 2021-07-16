import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

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

  int? sortColumnIndex; //Reflects the column that is currently sorted!
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    _fetchTotalUserResults();
    print(_currentUser.token);
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
    final deviceSize = MediaQuery.of(context).size;

    if (_currentUser.token == null || _currentUser.usertype != "admin") {
      return NoTokenScreen();
    } else {
      final _myBureauResultsProvider = context.watch<BureauResultsProvider>();
      return Scaffold(
        appBar: AppBar(
          title: Text("Begrüssungs- und Erreichbarkeitstrainer"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list_alt),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.build_rounded),
              onPressed: () {
                context.vxNav.push(
                  Uri.parse(MyRoutes.adminRoute),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                context.vxNav.push(
                  Uri.parse(MyRoutes.adminProfilRoute),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
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
        body:
            /* DataTableDemo() */ Container(
          padding: const EdgeInsets.all(100.0),
          child: ListView(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Admin Ansicht",
                  style: TextStyle(fontSize: 42),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Resultate der Büros für ${_currentUser.username}",
                  style: const TextStyle(fontSize: 34),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 2,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: bureauResultsData(_myBureauResultsProvider),
              ),
            ],
          ),
        ),
      );
    }
  }

  final columns = [
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
    "AB aufgeschaltet (falls nicht erreicht)",
    "AB Nachricht korrekt",
    "rateCallbackDoneNoAnswer",
    "rateCallbackDoneResponder",
    "Rückruf nach AB innerhalb der Zeit",
    "Durchschnittliche Klingelzeit",
  ];

  Widget bureauResultsData(BureauResultsProvider _myBureauResultsProvider) {
    if (_isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return DataTable(
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: getRows(_myBureauResultsProvider.bureauResults),
      );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(column),
          onSort: onSort,
        ),
      )
      .toList();

  List<DataRow> getRows(List<BureauResults> bureauResults) =>
      bureauResults.map((BureauResults data) {
        final cells = [
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
          data.rateCallbackDoneNoAnswer + "%",
          data.rateCallbackDoneResponder + "%",
          data.rateCallbackInTime + "%",
          data.meanRingingTime != "-"
              ? double.parse(data.meanRingingTime).toStringAsFixed(2) +
                  " Sekunden"
              : "-",
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      bureauResults.sort((user1, user2) =>
          compareString(ascending, user1.bureau, user2.bureau));
    } else if (columnIndex == 1) {
      bureauResults.sort((user1, user2) => compareInteger(
            ascending,
            int.parse(user1.totalCalls),
            int.parse(user2.totalCalls),
          ));
    } else if (columnIndex == 2) {
      bureauResults.sort((user1, user2) => compareInteger(
            ascending,
            int.parse(user1.totalCallsReached),
            int.parse(user2.totalCallsReached),
          ));
    } else if (columnIndex == 3) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateSaidOrganization != "-"
                ? double.parse(user1.rateSaidOrganization)
                : -1.0,
            user2.rateSaidOrganization != "-"
                ? double.parse(user2.rateSaidOrganization)
                : -1.0,
          ));
    } else if (columnIndex == 4) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateSaidBureau != "-"
                ? double.parse(user1.rateSaidBureau)
                : -1.0,
            user2.rateSaidBureau != "-"
                ? double.parse(user2.rateSaidBureau)
                : -1.0,
          ));
    } else if (columnIndex == 5) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateSaidDepartment != "-"
                ? double.parse(user1.rateSaidDepartment)
                : -1.0,
            user2.rateSaidDepartment != "-"
                ? double.parse(user2.rateSaidDepartment)
                : -1.0,
          ));
    } else if (columnIndex == 6) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateSaidFirstname != "-"
                ? double.parse(user1.rateSaidFirstname)
                : -1.0,
            user2.rateSaidFirstname != "-"
                ? double.parse(user2.rateSaidFirstname)
                : -1.0,
          ));
    } else if (columnIndex == 7) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateSaidName != "-" ? double.parse(user1.rateSaidName) : -1.0,
            user2.rateSaidName != "-" ? double.parse(user2.rateSaidName) : -1.0,
          ));
    } else if (columnIndex == 8) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateSaidGreeting != "-"
                ? double.parse(user1.rateSaidGreeting)
                : -1.0,
            user2.rateSaidGreeting != "-"
                ? double.parse(user2.rateSaidGreeting)
                : -1.0,
          ));
    } else if (columnIndex == 9) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateSaidSpecificWords != "-"
                ? double.parse(user1.rateSaidSpecificWords)
                : -1.0,
            user2.rateSaidSpecificWords != "-"
                ? double.parse(user2.rateSaidSpecificWords)
                : -1.0,
          ));
    } else if (columnIndex == 10) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateReached != "-" ? double.parse(user1.rateReached) : -1.0,
            user2.rateReached != "-" ? double.parse(user2.rateReached) : -1.0,
          ));
    } else if (columnIndex == 11) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.rateCallCompleted != "-"
                ? double.parse(user1.rateCallCompleted)
                : -1.0,
            user2.rateCallCompleted != "-"
                ? double.parse(user2.rateCallCompleted)
                : -1.0,
          ));
    } else if (columnIndex == 12) {
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
    } else if (columnIndex == 16) {
      bureauResults.sort((user1, user2) => compareDouble(
            ascending,
            user1.meanRingingTime != "-"
                ? double.parse(user1.meanRingingTime)
                : -1.0,
            user2.meanRingingTime != "-"
                ? double.parse(user2.meanRingingTime)
                : -1.0,
          ));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareInteger(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareDouble(bool ascending, double value1, double value2) {
    return ascending ? value1.compareTo(value2) : value2.compareTo(value1);
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