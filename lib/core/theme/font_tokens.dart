import 'package:flutter/material.dart';

/// 5 Curated Font Style Options supported by Orbit Todo.
enum AppFontStyle {
  modern,
  rounded,
  editorial,
  geometric,
  classic,
}

extension AppFontStyleExtension on AppFontStyle {
  String get displayName => switch (this) {
        AppFontStyle.modern => 'Modern',
        AppFontStyle.rounded => 'Rounded',
        AppFontStyle.editorial => 'Editorial',
        AppFontStyle.geometric => 'Geometric',
        AppFontStyle.classic => 'Classic',
      };

  String get description => switch (this) {
        AppFontStyle.modern => 'Clean, neutral Inter sans-serif',
        AppFontStyle.rounded => 'Warm, friendly Nunito Sans',
        AppFontStyle.editorial => 'Journal-style Source Serif headings',
        AppFontStyle.geometric => 'Crisp, structured Manrope',
        AppFontStyle.classic => 'Native platform UI typography',
      };
}
