import 'package:flutter/material.dart';

class AppStyle {
  // Colors
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color errorColor;
  final Color themeBlack;
  final Color buttonBackgroundColor;
  final Color buttonBorderColor;

  final Color IconColor;
  final Color themeWhite;

  // Borders
  final double borderThickness;
  final double borderRadiusSmall;
  final double borderRadiusMedium;
  final double borderRadiusLarge;

  // Font sizes
  final double titleFontSize;
  final double subtitleFontSize;
  final double bodyFontSize;
  final double captionFontSize;
  final double buttonFontSize;

  // Padding
  final double paddingSmall;
  final double paddingMedium;
  final double paddingLarge;

  AppStyle({
    this.primaryColor = const Color(0xFF83C9CB),
    this.secondaryColor = const Color(0xFF87BBA2),
    this.tertiaryColor = const Color(0xFF55828B),
    this.accentColor = const Color(0xFFC9E4CA),
    this.backgroundColor = const Color(0xFFF4EEE6),
    this.buttonBackgroundColor = Colors.white,
    this.buttonBorderColor = const Color(0xFFBDBDBD),
    this.IconColor = const Color(0xFF55828B),
    this.errorColor = const Color(0xFFC75B5B),
    this.themeBlack = const Color(0xFF545252),
    this.themeWhite = const Color(0xFFF5F5F5),
    // Borders
    this.borderThickness = 2.0,
    this.borderRadiusSmall = 4.0,
    this.borderRadiusMedium = 8.0,
    this.borderRadiusLarge = 16.0,

    // Fonts
    this.titleFontSize = 22.0,
    this.subtitleFontSize = 18.0,
    this.bodyFontSize = 16.0,
    this.captionFontSize = 12.0,
    this.buttonFontSize = 14.0,

    // Padding
    this.paddingSmall = 8.0,
    this.paddingMedium = 16.0,
    this.paddingLarge = 24.0,
  });

  // Default theme
  factory AppStyle.defaultStyle() => AppStyle();

  // Map serialization
  factory AppStyle.fromMap(Map<String, dynamic> map) {
    return AppStyle(
      primaryColor: Color(int.parse(map['primary_color'] ?? '0xFF4A90E2')),
      accentColor: Color(int.parse(map['accent_color'] ?? '0xFFFFC107')),
      backgroundColor:
          Color(int.parse(map['background_color'] ?? '0xFFF5F5F5')),
      secondaryColor: Color(int.parse(map['secondary_color'] ?? '0xFF50E3C2')),
      tertiaryColor: Color(int.parse(map['tertiary_color'] ?? '0xFF9013FE')),
      errorColor: Color(int.parse(map['error_color'] ?? '0xFFD0021B')),
      borderThickness: (map['border_thickness'] ?? 2.0).toDouble(),
      borderRadiusSmall: (map['border_radius_small'] ?? 4.0).toDouble(),
      borderRadiusMedium: (map['border_radius_medium'] ?? 8.0).toDouble(),
      borderRadiusLarge: (map['border_radius_large'] ?? 16.0).toDouble(),
      titleFontSize: (map['title_font_size'] ?? 22.0).toDouble(),
      subtitleFontSize: (map['subtitle_font_size'] ?? 18.0).toDouble(),
      bodyFontSize: (map['body_font_size'] ?? 16.0).toDouble(),
      captionFontSize: (map['caption_font_size'] ?? 12.0).toDouble(),
      buttonFontSize: (map['button_font_size'] ?? 14.0).toDouble(),
      paddingSmall: (map['padding_small'] ?? 8.0).toDouble(),
      paddingMedium: (map['padding_medium'] ?? 16.0).toDouble(),
      paddingLarge: (map['padding_large'] ?? 24.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primary_color': primaryColor.value.toString(),
      'accent_color': accentColor.value.toString(),
      'background_color': backgroundColor.value.toString(),
      'secondary_color': secondaryColor.value.toString(),
      'tertiary_color': tertiaryColor.value.toString(),
      'error_color': errorColor.value.toString(),
      'border_thickness': borderThickness,
      'border_radius_small': borderRadiusSmall,
      'border_radius_medium': borderRadiusMedium,
      'border_radius_large': borderRadiusLarge,
      'title_font_size': titleFontSize,
      'subtitle_font_size': subtitleFontSize,
      'body_font_size': bodyFontSize,
      'caption_font_size': captionFontSize,
      'button_font_size': buttonFontSize,
      'padding_small': paddingSmall,
      'padding_medium': paddingMedium,
      'padding_large': paddingLarge,
    };
  }

  // Copy with
  AppStyle copyWith({
    Color? primaryColor,
    Color? accentColor,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? errorColor,
    double? borderThickness,
    double? borderRadiusSmall,
    double? borderRadiusMedium,
    double? borderRadiusLarge,
    double? titleFontSize,
    double? subtitleFontSize,
    double? bodyFontSize,
    double? captionFontSize,
    double? buttonFontSize,
    double? paddingSmall,
    double? paddingMedium,
    double? paddingLarge,
  }) {
    return AppStyle(
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      errorColor: errorColor ?? this.errorColor,
      borderThickness: borderThickness ?? this.borderThickness,
      borderRadiusSmall: borderRadiusSmall ?? this.borderRadiusSmall,
      borderRadiusMedium: borderRadiusMedium ?? this.borderRadiusMedium,
      borderRadiusLarge: borderRadiusLarge ?? this.borderRadiusLarge,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
      bodyFontSize: bodyFontSize ?? this.bodyFontSize,
      captionFontSize: captionFontSize ?? this.captionFontSize,
      buttonFontSize: buttonFontSize ?? this.buttonFontSize,
      paddingSmall: paddingSmall ?? this.paddingSmall,
      paddingMedium: paddingMedium ?? this.paddingMedium,
      paddingLarge: paddingLarge ?? this.paddingLarge,
    );
  }
}
