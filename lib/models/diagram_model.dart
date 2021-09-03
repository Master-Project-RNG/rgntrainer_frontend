import 'package:rgntrainer_frontend/models/bureau_results_model.dart';

class Diagram {
  DateTime date;
  String bureau;
  BureauStatistics bureauStatistics;
  AbAndCallbackStatistics abAndCallbackStatistics;

  Diagram({
    required this.date,
    required this.bureau,
    required this.bureauStatistics,
    required this.abAndCallbackStatistics,
  });

  /// Factory method to create a dart object out of a json
  factory Diagram.fromJson(Map<String, dynamic> json) => Diagram(
        date: DateTime.parse(json["date"]),
        bureau: json["bureau"].toString(),
        bureauStatistics: BureauStatistics.fromJson(json['bureauStatistics']),
        abAndCallbackStatistics: AbAndCallbackStatistics.fromJson(
          json['abAndCallbackStatistics'],
        ),
      );
}
