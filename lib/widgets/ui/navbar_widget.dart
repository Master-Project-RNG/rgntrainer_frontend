import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class NavBarWidget extends StatefulWidget {
  final User _currentUser;

  const NavBarWidget(this._currentUser);

  @override
  _NavBarWidgetState createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  late bool _showAbfragenTab;

  @override
  void initState() {
    super.initState();
    _showAbfragenTab = UserSimplePreferences.getAbfrageTabOpen();
  }

  double animatedHeight = 0;

  @override
  Widget build(BuildContext context) {
    if (_showAbfragenTab == true) {
      animatedHeight = 50;
    } else {
      animatedHeight = 0;
    }
    return Column(
      children: [
        Container(
          height: 65,
          width: 200,
          color: Theme.of(context).accentColor,
        ),
        Container(
          height: 180,
          width: 200,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.white,
              ),
              Text(
                widget._currentUser.username.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Column(
          children: [
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            Container(
              height: 50,
              width: 200,
              color: Theme.of(context).primaryColor,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(25, 177, 237, 1), //cyan
                  ),
                ),
                onPressed: () {
                  context.vxNav.push(
                    Uri.parse(MyRoutes.adminCockpitRoute),
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                      child: Icon(
                        Icons.category,
                      ),
                    ),
                    Text(
                      "Cockpit",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            Container(
              height: 50,
              width: 200,
              color: Theme.of(context).primaryColor,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(25, 177, 237, 1), //cyan
                  ),
                ),
                onPressed: () {
                  context.vxNav.push(
                    Uri.parse(MyRoutes.adminNumbersRoute),
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                      child: Icon(
                        Icons.call,
                      ),
                    ),
                    Text(
                      "Nummern",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            Container(
              height: 50,
              width: 200,
              color: Theme.of(context).primaryColor,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(25, 177, 237, 1), //cyan
                  ),
                ),
                onPressed: () {
                  context.vxNav.push(
                    Uri.parse(MyRoutes.adminConfigRoute),
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                      child: Icon(
                        Icons.build_rounded,
                      ),
                    ),
                    Text(
                      "Konfiguration",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            Container(
              height: 50,
              width: 200,
              color: Theme.of(context).primaryColor,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(25, 177, 237, 1), //cyan
                  ),
                ),
                onPressed: () {
                  if (_showAbfragenTab == true) {
                    UserSimplePreferences.setAbfrageTabOpen(false);
                    _showAbfragenTab = false;
                  } else {
                    UserSimplePreferences.setAbfrageTabOpen(true);
                    _showAbfragenTab = true;
                  }
                  setState(() {
                    animatedHeight == 0
                        ? animatedHeight = 50
                        : animatedHeight = 0;
                  });
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                      child: Icon(
                        Icons.filter_alt_rounded,
                      ),
                    ),
                    Text(
                      "Abfragen",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    SizedBox(
                      width: 30,
                      child: animatedHeight == 0
                          ? Icon(
                              Icons.keyboard_arrow_down,
                            )
                          : Icon(
                              Icons.keyboard_arrow_up,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: animatedHeight,
              width: 200,
              color: Theme.of(context).primaryColor,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(25, 177, 237, 1), //cyan
                  ),
                ),
                onPressed: () {
                  context.vxNav.push(
                    Uri.parse(MyRoutes.adminResultsRoute),
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      width: 50,
                      child: Icon(
                        Icons.manage_search,
                      ),
                    ),
                    Text(
                      "Resultate",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: animatedHeight == 0 ? 0 : 1,
                  width: 30,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  height: animatedHeight == 0 ? 0 : 1,
                  width: 170,
                  color: Colors.white,
                ),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: animatedHeight,
              width: 200,
              color: Theme.of(context).primaryColor,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(25, 177, 237, 1), //cyan
                  ),
                ),
                onPressed: () {
                  context.vxNav.push(
                    Uri.parse(MyRoutes.adminDiagramRoute),
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      width: 50,
                      child: Icon(
                        Icons.query_stats,
                      ),
                    ),
                    Text(
                      "Diagramme",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            width: 200,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
