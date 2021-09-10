import 'package:flutter/material.dart';

Future<T?> showStatusTextDialog<T>(
  BuildContext context, {
  required String title,
  required bool value,
}) =>
    showDialog<T>(
      context: context,
      builder: (context) => TextDialogWidget(
        title: title,
        value: value,
      ),
    );

class TextDialogWidget extends StatefulWidget {
  final String title;
  final bool value;

  const TextDialogWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var _value = widget.value;

    return AlertDialog(
      title: Text(widget.title),
      content: Container(
          child: _value == true
              ? Text("Diese Nummer ist aktiv. Deaktivieren?")
              : Text("Diese Nummer ist deaktiviert. Aktivieren?")),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        _value == true
            ? ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Deaktvieren'))
            : ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Aktivieren'))
      ],
    );
  }
}
