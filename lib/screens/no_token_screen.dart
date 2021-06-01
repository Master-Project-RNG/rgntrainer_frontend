import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/my_routes.dart';
import 'package:velocity_x/velocity_x.dart';

class NoTokenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoTokenCard();
  }
}

class NoTokenCard extends StatefulWidget {
  const NoTokenCard({
    Key? key,
  }) : super(key: key);

  @override
  _NoTokenCardState createState() => _NoTokenCardState();
}

class _NoTokenCardState extends State<NoTokenCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Begrüssungs- und Erreichbarkeitstrainer"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: AlertDialog(
          title: Text('Fehler!'),
          content: Text("Kein gültiger Token!"),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Okay!'),
              onPressed: () {
                context.vxNav.replace(
                  Uri.parse(MyRoutes.loginRoute),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
