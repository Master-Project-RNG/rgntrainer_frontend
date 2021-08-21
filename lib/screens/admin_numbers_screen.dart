import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/numbers_model.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/provider/admin_numbers_provider.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
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

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    _asyncData();
    print("CurrentUserToken: ${_currentUser.token!}");
    initializeDateFormatting(); //set CalendarWidget language to German
  }

  //Fetch all Listings
  Future _asyncData() async {
    setState(() {
      _isLoading = true;
    });
    _numbers = await Provider.of<NumbersProvider>(context, listen: false)
        .getAllUsersNumbers(_currentUser.token);
    setState(() {
      _isLoading = false;
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
                    padding: EdgeInsets.only(left: 50, top: 50),
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
}
