import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.mainColor,
    required this.secondColor,
    required this.highlightColor, 
    required this.dark, 
    required this.light,
  });

  final Color? mainColor;
  final Color? secondColor;
  final Color? highlightColor;
  final Color? dark;
  final Color? light;

  @override
  AppColors copyWith({
    Color? mainColor,
    Color? secondColor,
    Color? highlightColor,
    Color? dark,
    Color? light,
  }) =>
      AppColors(
        mainColor: mainColor ?? this.mainColor,
        secondColor: secondColor ?? this.secondColor,
        highlightColor: highlightColor ?? this.highlightColor,
        dark: dark ?? this.dark,
        light: light ?? this.light,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      mainColor: Color.lerp(mainColor, other.mainColor, t),
      secondColor: Color.lerp(secondColor, other.secondColor, t),
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t),
      dark: Color.lerp(dark, other.dark, t),
      light: Color.lerp(light, other.light, t),
    );
  }
}