import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/numbers_model.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_numbers_provider.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/widgets/text_dialog_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/calendar_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/navbar_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/title_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/date_symbol_data_local.dart';

class AdminNumbersScreen extends StatefulWidget {
  const AdminNumbersScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AdminNumbersState createState() => _AdminNumbersState();
}

class _AdminNumbersState extends State<AdminNumbersScreen> {
  late User _currentUser = User.init();
  var _isLoading = false;

  List<Number> _numbers = [];
  List<Number> _numberPerBureau = [];

  List<String> _getBureausNames = [];
  String pickedBureau = '';

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    _asyncData();
    // ignore: avoid_print
    print("CurrentUserToken: ${_currentUser.token!}");
    initializeDateFormatting(); //set CalendarWidget language to German
  }

  //Fetch all Listings
  Future _asyncData() async {
    setState(() {
      _isLoading = true;
    });
    _getBureausNames =
        await Provider.of<BureauResultsProvider>(context, listen: false)
            .getBureausNames(_currentUser.token);
    pickedBureau = _getBureausNames[0];
    _numbers = await Provider.of<NumbersProvider>(context, listen: false)
        .getAllUsersNumbers(_currentUser.token);
    numberPerBureau();

    ///testing
    /*await Provider.of<NumbersProvider>(context, listen: false).createUser(
        _currentUser.token,
        "number",
        "bureau",
        "department",
        "firstName",
        "lastName",
        "email",
        context);*/
    setState(() {
      _isLoading = false;
    });
  }

  void numberPerBureau() {
    _numberPerBureau = [];
    // ignore: avoid_function_literals_in_foreach_calls
    _numbers.forEach((element) {
      if (element.bureau == pickedBureau) {
        _numberPerBureau.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser.token == null || _currentUser.usertype != "admin") {
      return NoTokenScreen();
    } else {
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
                    icon: const Icon(
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
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      AuthProvider().logout(_currentUser.token!);
                      context.vxNav.clearAndPush(
                        Uri.parse(MyRoutes.loginRoute),
                      );
                    },
                  )
                ],
                automaticallyImplyLeading: false,
              ),
              body: Column(
                children: [
                  TitleWidget("Nummern"),
                  Container(
                    padding: const EdgeInsets.only(left: 50, top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nummern der Büros für ${_currentUser.username}",
                          style: const TextStyle(fontSize: 34),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: Colors.grey[200],
                            child: buildDataTable(),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  final columns = [
    "number",
    "bureau",
    "department",
    "firstname",
    "lastname",
    "email",
  ];

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(label: Text(column));
    }).toList();
  }

  List<DataRow> getRows(List<Number> numbers) => numbers.map((Number number) {
        final cells = [
          number.number,
          number.bureau,
          number.department,
          number.firstname,
          number.lastname,
          number.email
        ];

        return DataRow(
          cells: modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 3 || index == 4 || index == 5;
            return DataCell(
              Text('$cell'),
              showEditIcon: showEditIcon,
              onTap: () {
                switch (index) {
                  case 3:
                    editFirstName(number);
                    break;
                  case 4:
                    editLastName(number);
                    break;
                  case 5:
                    editEmail(number);
                    break;
                }
              },
            );
          }),
        );
      }).toList();

  Future editFirstName(Number editUser) async {
    final firstName = await showTextDialog(
      context,
      title: 'Change First Name',
      value: editUser.firstname,
    );

    setState(() => _numbers = _numbers.map((user) {
          final isEditedUser = user == editUser;
          return isEditedUser ? user.copy(firstname: firstName) : user;
        }).toList());
  }

  Future editLastName(Number editUser) async {
    final lastName = await showTextDialog(
      context,
      title: 'Change Last Name',
      value: editUser.lastname,
    );

    setState(() => _numbers = _numbers.map((user) {
          final isEditedUser = user == editUser;
          return isEditedUser ? user.copy(lastname: lastName) : user;
        }).toList());
  }

  Future editEmail(Number editUser) async {
    final eMail = await showTextDialog(
      context,
      title: 'Change Email',
      value: editUser.email,
    );

    setState(() => _numbers = _numbers.map((user) {
          final isEditedUser = user == editUser;
          return isEditedUser ? user.copy(email: eMail) : user;
        }).toList());
  }

  Widget buildDataTable() {
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(_numbers),
    );
  }

  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}
