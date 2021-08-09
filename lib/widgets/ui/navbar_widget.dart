import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:velocity_x/velocity_x.dart';

class NavBarWidget extends StatelessWidget {
  final User _currentUser;

  const NavBarWidget(this._currentUser);

  @override
  Widget build(BuildContext context) {
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
                _currentUser.username.toString(),
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
                onPressed: () {},
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                      child: Icon(
                        Icons.call,
                      ),
                    ),
                    Text(
                      "Nummern (inactive)",
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
                  context.vxNav.push(
                    Uri.parse(MyRoutes.adminResultsRoute),
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                      child: Icon(
                        Icons.list_alt,
                      ),
                    ),
                    Text(
                      "Abfragen",
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
