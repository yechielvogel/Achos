import 'package:flutter/material.dart';

class AppStyle {
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color errorColor;
  final double borderThickness;
  final double titleFontSize;
  final double bodyFontSize;
  final double subtitleFontSize;
  final double buttonFontSize;

  AppStyle({
    this.primaryColor = const Color(0xFF6200EA),
    this.accentColor = const Color(0xFFFF5722),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.secondaryColor = const Color(0xFF03DAC6),
    this.tertiaryColor = const Color(0xFFBB86FC),
    this.errorColor = const Color(0xFFB00020),
    this.borderThickness = 2.0,
    this.titleFontSize = 20.0,
    this.bodyFontSize = 16.0,
    this.subtitleFontSize = 18.0,
    this.buttonFontSize = 14.0,
  });

  factory AppStyle.defaultStyle() {
    return AppStyle(
      primaryColor: const Color(0xFF6200EA),
      accentColor: const Color(0xFFFF5722),
      backgroundColor: const Color(0xFFFFFFFF),
      secondaryColor: const Color(0xFF03DAC6),
      tertiaryColor: const Color(0xFFBB86FC),
      errorColor: const Color(0xFFB00020),
      borderThickness: 2.0,
      titleFontSize: 20.0,
      bodyFontSize: 16.0,
      subtitleFontSize: 18.0,
      buttonFontSize: 14.0,
    );
  }

  factory AppStyle.fromMap(Map<String, dynamic> map) {
    return AppStyle(
      primaryColor: Color(int.parse(map['primary_color'] ?? '0xFF6200EA')),
      accentColor: Color(int.parse(map['accent_color'] ?? '0xFFFF5722')),
      backgroundColor:
          Color(int.parse(map['background_color'] ?? '0xFFFFFFFF')),
      secondaryColor: Color(int.parse(map['secondary_color'] ?? '0xFF03DAC6')),
      tertiaryColor: Color(int.parse(map['tertiary_color'] ?? '0xFFBB86FC')),
      errorColor: Color(int.parse(map['error_color'] ?? '0xFFB00020')),
      borderThickness: (map['border_thickness'] ?? 2.0).toDouble(),
      titleFontSize: (map['title_font_size'] ?? 20.0).toDouble(),
      bodyFontSize: (map['body_font_size'] ?? 16.0).toDouble(),
      subtitleFontSize: (map['subtitle_font_size'] ?? 18.0).toDouble(),
      buttonFontSize: (map['button_font_size'] ?? 14.0).toDouble(),
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
      'title_font_size': titleFontSize,
      'body_font_size': bodyFontSize,
      'subtitle_font_size': subtitleFontSize,
      'button_font_size': buttonFontSize,
    };
  }

  AppStyle copyWith({
    Color? primaryColor,
    Color? accentColor,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? errorColor,
    double? borderThickness,
    double? titleFontSize,
    double? bodyFontSize,
    double? subtitleFontSize,
    double? buttonFontSize,
  }) {
    return AppStyle(
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      errorColor: errorColor ?? this.errorColor,
      borderThickness: borderThickness ?? this.borderThickness,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      bodyFontSize: bodyFontSize ?? this.bodyFontSize,
      subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
      buttonFontSize: buttonFontSize ?? this.buttonFontSize,
    );
  }
}
