import 'package:flutter/material.dart';
import '../../../data/local/database.dart';

/// Domain entity for a Tag / Label.
class TagEntity {
  const TagEntity({required this.tag});

  final Tag tag;

  String get id => tag.id;
  String get name => tag.name;
  String get colorHex => tag.colorHex;
  DateTime get createdAt => tag.createdAt;

  /// Parses the hex color string into a [Color].
  Color get color {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFF6B7280);
    }
  }
}
