import 'package:flutter/material.dart';

class AppTheme {
  static const gold = Color(0xFFD4AF37);
  static const navy = Color(0xFF0D1B3E);
  static const cyan = Color(0xFF00D4FF);
  static const white = Colors.white;
  static const background = Color(0xFFF9F9F7);
  static const darkText = Color(0xFF1A1A1A);
  static const greyText = Color(0xFF6B7280);
  static const lightGrey = Color(0xFFF3F4F6);

  static ThemeData get theme => ThemeData(
    primaryColor: gold,
    scaffoldBackgroundColor: background,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.light(
      primary: gold,
      secondary: gold,
      surface: white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: darkText,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      iconTheme: IconThemeData(color: darkText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkText,
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    cardTheme: CardThemeData(
      color: white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: darkText, fontWeight: FontWeight.bold, fontSize: 28),
      headlineMedium: TextStyle(color: darkText, fontWeight: FontWeight.bold, fontSize: 22),
      headlineSmall: TextStyle(color: darkText, fontWeight: FontWeight.bold, fontSize: 18),
      bodyLarge: TextStyle(color: darkText, fontSize: 16),
      bodyMedium: TextStyle(color: greyText, fontSize: 14),
      bodySmall: TextStyle(color: greyText, fontSize: 12),
    ),
  );
}
