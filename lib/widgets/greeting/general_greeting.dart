import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:rgntrainer_frontend/widgets/greeting/single_row.dart';
import 'package:rgntrainer_frontend/widgets/greeting/single_row_specific_words.dart';

class GeneralGreetingConfigurationWidget extends StatelessWidget {
  final String id;
  final GreetingConfiguration? greetingConfig;
  final String tabType;
  final Map<String, dynamic> _greetingData;
  final String? bureau;
  final String? department;
  final String? organization;
  final String? salutation;

  const GeneralGreetingConfigurationWidget(
    this.id,
    this.greetingConfig,
    this.tabType,
    this._greetingData, {
    this.bureau,
    this.department,
    this.organization,
    this.salutation,
  });

  @override
  Widget build(BuildContext context) {
    if (_greetingData[id + "_Bureau"] == null) {
      _greetingData[id + "_Bureau"] = greetingConfig?.bureau;
    }
    (_greetingData[id + "_Department"] == null)
        ? _greetingData[id + "_Department"] = greetingConfig?.department
        : null;
    _greetingData[id + "_Vorname"] == null
        ? _greetingData[id + "_Vorname"] = greetingConfig?.firstName
        : null;
    _greetingData[id + "_Nachname"] == null
        ? _greetingData[id + "_Nachname"] = greetingConfig?.lastName
        : null;
    _greetingData[id + "_Organization"] == null
        ? _greetingData[id + "_Organization"] = greetingConfig?.organizationName
        : null;
    _greetingData[id + "_Begrüssung"] == null
        ? _greetingData[id + "_Begrüssung"] = greetingConfig?.salutation
        : null;
    return Column(
      children: [
        SingleRowConfig(id, "Bureau", greetingConfig?.bureau, _greetingData),
        SingleRowConfig(
            id, "Department", greetingConfig?.department, _greetingData),
        SingleRowConfig(
            id, "Vorname", greetingConfig?.firstName, _greetingData),
        SingleRowConfig(
            id, "Nachname", greetingConfig?.lastName, _greetingData),
        SingleRowConfig(id, "Organization", greetingConfig?.organizationName,
            _greetingData),
        SingleRowConfig(
            id, "Begrüssung", greetingConfig?.salutation, _greetingData),
        //singleRowCallConfig(id, "Bureau", greetingConfig.organizationName),
        SingleRowSpecWordsConfig(
            id, "specificWords", greetingConfig!.specificWords, tabType),
      ],
    );
  }
}
