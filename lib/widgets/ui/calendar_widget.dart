import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return IntrinsicHeight(
          child: Row(
            children: [
              const VerticalDivider(
                indent:
                    56, //56 is the default Height of the toolbar. It needs to be set here, in order to have the right height for the intrinsicHeight
                width: 2,
                color: Colors.white,
              ),
              SizedBox(
                width: 70,
                child: Center(
                  child: Text(
                    DateFormat('dd').format(DateTime.now()),
                    style: const TextStyle(fontSize: 34, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEEE', "de_CH").format(DateTime.now()),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      DateFormat('MMMM', "de_CH").format(DateTime.now()),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      "KW ${DateTime.now().weekOfYear}",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(
                width: 2,
                color: Colors.white,
              ),
              SizedBox(
                width: 60,
                child: Center(
                  child: Text(
                    DateFormat('HH:mm').format(DateTime.now()),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const VerticalDivider(
                width: 2,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
