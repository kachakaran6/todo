/// Curated Font Style Options supported by Orbit Todo.
enum AppFontStyle {
  modern,
  rounded,
  editorial,
  geometric,
  classic,
  handwriting, // Caveat
  display,     // Bebas Neue
  serif,       // Lora
}

extension AppFontStyleExtension on AppFontStyle {
  String get displayName => switch (this) {
        AppFontStyle.modern => 'Modern',
        AppFontStyle.rounded => 'Rounded',
        AppFontStyle.editorial => 'Editorial',
        AppFontStyle.geometric => 'Geometric',
        AppFontStyle.classic => 'Classic',
        AppFontStyle.handwriting => 'Caveat (Handwriting)',
        AppFontStyle.display => 'Bebas Neue (Display)',
        AppFontStyle.serif => 'Lora (Serif)',
      };

  String get description => switch (this) {
        AppFontStyle.modern => 'Clean, neutral Inter sans-serif',
        AppFontStyle.rounded => 'Warm, friendly Nunito Sans',
        AppFontStyle.editorial => 'Journal-style Source Serif headings',
        AppFontStyle.geometric => 'Crisp, structured Manrope',
        AppFontStyle.classic => 'Native platform UI typography',
        AppFontStyle.handwriting => 'Expressive handwritten style with Caveat',
        AppFontStyle.display => 'Bold, high-impact condensed style with Bebas Neue',
        AppFontStyle.serif => 'Elegant, literary serif typography with Lora',
      };
}
