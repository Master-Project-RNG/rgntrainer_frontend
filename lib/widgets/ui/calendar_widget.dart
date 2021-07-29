import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return Container(
            child: IntrinsicHeight(
              child: Row(
                children: [
                  VerticalDivider(
                    indent:
                        56, //56 is the default Height of the toolbar. It needs to be set here, in order to have the right height for the intrinsicHeight
                    width: 2,
                    color: Colors.white,
                  ),
                  Container(
                    width: 70,
                    child: Center(
                      child: Text(
                        DateFormat('dd').format(DateTime.now()),
                        style: TextStyle(fontSize: 34, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEEE', "de_CH").format(DateTime.now()),
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          DateFormat('MMMM', "de_CH").format(DateTime.now()),
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "KW " + DateTime.now().weekOfYear.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    width: 2,
                    color: Colors.white,
                  ),
                  Container(
                    width: 60,
                    child: Center(
                      child: Text(
                        DateFormat('HH:mm').format(DateTime.now()),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 2,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
