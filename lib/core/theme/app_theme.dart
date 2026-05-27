import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.surfaceLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLight,
        background: AppColors.backgroundLight,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.outfit(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.outfit(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.outfit(color: AppColors.textPrimaryLight),
        bodyMedium: GoogleFonts.outfit(color: AppColors.textSecondaryLight),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: GoogleFonts.outfit(color: AppColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.surfaceDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.outfit(color: AppColors.textPrimaryDark),
        bodyMedium: GoogleFonts.outfit(color: AppColors.textSecondaryDark),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: GoogleFonts.outfit(color: AppColors.textPrimaryDark, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      useMaterial3: true,
    );
  }
}
