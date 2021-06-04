import 'package:flutter/material.dart';

class SingleRowConfig extends StatefulWidget {
  final String id;
  final String inhalt;
  final bool? greetingConfigBoolean;
  final Map<String, dynamic> greetingData;

  const SingleRowConfig(
      this.id, this.inhalt, this.greetingConfigBoolean, this.greetingData);

  @override
  _SingleRowConfigState createState() => _SingleRowConfigState();
}

class _SingleRowConfigState extends State<SingleRowConfig> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Used for managing the different openinHours
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 40,
          width: 100,
          child: Text(widget.inhalt),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 40,
          width: 60,
          child: Checkbox(
            value: widget.greetingData['${widget.id}_${widget.inhalt}'],
            onChanged: (value) {
              setState(() {
                widget.greetingData['${widget.id}_${widget.inhalt}'] = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
