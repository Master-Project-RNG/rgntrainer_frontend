import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    } else if (_isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
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
                  "Resultate der Büros für ${_currentUser.organization}",
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
    "Rückruf nach AB",
    "Rückruf nach AB innerhalb der Zeit",
    "Durchschnittliche Klingelzeit",
  ];

  Widget bureauResultsData(BureauResultsProvider _myBureauResultsProvider) {
    return DataTable(
        columns: getColumns(columns),
        rows: _myBureauResultsProvider.bureauResults
            .map((data) => DataRow(cells: [
                  DataCell(Text(data.bureau.toString())),
                  DataCell(Text(data.totalCalls.toString())),
                  DataCell(Text(data.totalCallsReached.toString())),
                  DataCell(Text(data.rateSaidOrganization + "%")),
                  DataCell(Text(data.rateSaidBureau + "%")),
                  DataCell(Text(data.rateSaidDepartment + "%")),
                  DataCell(Text(data.rateSaidFirstname + "%")),
                  DataCell(Text(data.rateSaidName + "%")),
                  DataCell(Text(data.rateSaidGreeting + "%")),
                  DataCell(Text(data.rateSaidSpecificWords + "%")),
                  DataCell(Text(data.rateReached + "%")),
                  DataCell(Text(data.rateCallCompleted + "%")),
                  DataCell(Text(data.rateResponderStartedIfNotReached + "%")),
                  DataCell(Text(data.rateResponderCorrect + "%")),
                  DataCell(Text(data.rateCallbackDone + "%")),
                  DataCell(Text(data.rateCallbackInTime + "%")),
                  DataCell(Text(data.meanRingingTime + "Sekunden")),
                ]))
            .toList());
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            // onSort: onSort,
          ))
      .toList();
}
