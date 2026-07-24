import 'package:flutter/material.dart';

enum CustomFieldType {
  text,
  number,
  checkbox,
  singleSelect,
  date,
  url,
}

extension CustomFieldTypeX on CustomFieldType {
  String get nameString => switch (this) {
        CustomFieldType.text => 'text',
        CustomFieldType.number => 'number',
        CustomFieldType.checkbox => 'checkbox',
        CustomFieldType.singleSelect => 'single_select',
        CustomFieldType.date => 'date',
        CustomFieldType.url => 'url',
      };

  IconData get icon => switch (this) {
        CustomFieldType.text => Icons.short_text_rounded,
        CustomFieldType.number => Icons.numbers_rounded,
        CustomFieldType.checkbox => Icons.check_box_outlined,
        CustomFieldType.singleSelect => Icons.arrow_drop_down_circle_outlined,
        CustomFieldType.date => Icons.event_outlined,
        CustomFieldType.url => Icons.link_rounded,
      };
}

class CustomFieldDefinition {
  const CustomFieldDefinition({
    required this.id,
    required this.name,
    required this.type,
    this.projectId,
    this.optionsJson,
    this.defaultValue,
    this.isVisibleInDetails = true,
    this.isVisibleInRow = false,
  });

  final String id;
  final String name;
  final CustomFieldType type;
  final String? projectId;
  final String? optionsJson;
  final String? defaultValue;
  final bool isVisibleInDetails;
  final bool isVisibleInRow;
}
