import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);
  static const Color surfaceColor = Color(0xFFF5F5F5);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color onPrimaryColor = Color(0xFFFFFFFF);
  static const Color onSecondaryColor = Color(0xFF000000);
  static const Color onSurfaceColor = Color(0xFF000000);
  static const Color onBackgroundColor = Color(0xFF000000);
  static const Color onErrorColor = Color(0xFFFFFFFF);
  
  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF1976D2);
  static const Color darkSecondaryColor = Color(0xFF03DAC6);
  static const Color darkErrorColor = Color(0xFFCF6679);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkOnPrimaryColor = Color(0xFFFFFFFF);
  static const Color darkOnSecondaryColor = Color(0xFF000000);
  static const Color darkOnSurfaceColor = Color(0xFFFFFFFF);
  static const Color darkOnBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkOnErrorColor = Color(0xFF000000);
  
  // Chat Colors
  static const Color userMessageColor = Color(0xFF2196F3);
  static const Color aiMessageColor = Color(0xFFE0E0E0);
  static const Color darkUserMessageColor = Color(0xFF1976D2);
  static const Color darkAiMessageColor = Color(0xFF2C2C2C);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: surfaceColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onSurface: onSurfaceColor,
      onError: onErrorColor,
    ),
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headlineLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      elevation: AppConstants.defaultElevation,
      centerTitle: true,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onPrimaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: AppConstants.defaultElevation,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      error: darkErrorColor,
      surface: darkSurfaceColor,
      onPrimary: darkOnPrimaryColor,
      onSecondary: darkOnSecondaryColor,
      onSurface: darkOnSurfaceColor,
      onError: darkOnErrorColor,
    ),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: darkOnBackgroundColor,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: darkOnBackgroundColor,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: darkOnBackgroundColor,
      ),
      headlineLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: darkOnBackgroundColor,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: darkOnBackgroundColor,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: darkOnBackgroundColor,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: darkOnBackgroundColor,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: darkOnBackgroundColor,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: darkOnBackgroundColor,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: darkOnBackgroundColor,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: darkOnBackgroundColor,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: darkOnBackgroundColor,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkPrimaryColor,
      foregroundColor: darkOnPrimaryColor,
      elevation: AppConstants.defaultElevation,
      centerTitle: true,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkOnPrimaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: darkOnPrimaryColor,
        elevation: AppConstants.defaultElevation,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
    ),
  );
}