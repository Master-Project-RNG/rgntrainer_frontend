import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgntrainer_frontend/models/diagram_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/provider/admin_calls_provider.dart';
import 'package:rgntrainer_frontend/provider/auth_provider.dart';
import 'package:rgntrainer_frontend/provider/bureau_results_provider.dart';
import 'package:rgntrainer_frontend/screens/components/line_chart.dart';
import 'package:rgntrainer_frontend/screens/no_token_screen.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:rgntrainer_frontend/widgets/ui/calendar_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/navbar_widget.dart';
import 'package:rgntrainer_frontend/widgets/ui/title_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/date_symbol_data_local.dart';

class DiagramScreen extends StatefulWidget {
  @override
  _DiagramScreenState createState() => _DiagramScreenState();
}

class _DiagramScreenState extends State<DiagramScreen> {
  late User _currentUser = User.init();
  AdminCallsProvider adminCalls = AdminCallsProvider();

  @override
  void initState() {
    super.initState();
    _currentUser = UserSimplePreferences.getUser();
    initializeDateFormatting(); //Set language of CalendarWidget to German
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
              body: ListView(
                children: [
                  TitleWidget("Diagram"),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(50),
                          height: 600,
                          color: Colors.red,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.all(25),
                            child: LineChartSample1(title: "Overall"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 600,
                          color: Colors.yellow,
                        ),
                      )
                    ],
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
