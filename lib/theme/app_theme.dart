// healingbloom\lib\theme\app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Luxury color palette
  static const Color royalPlum = Color(0xFF4B0C66);
  static const Color velvetAmethyst = Color(0xFF703D8A);
  static const Color lavenderMist = Color(0xFFC2A1E6);
  static const Color opulentLilac = Color(0xFFE8DDF0);
  static const Color champagneGold = Color(0xFFE6C28E);
  static const Color pearlWhite = Color(0xFFFAF7F5);
  static const Color textColor = Color(0xFF2C1810);

  static BoxShadow get luxuryShadow => BoxShadow(
        color: Colors.black.withAlpha((0.1 * 255).toInt()),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 4),
      );

  static ThemeData lightTheme = ThemeData(
    primaryColor: royalPlum,
    scaffoldBackgroundColor: pearlWhite,
    textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
      displayLarge: const TextStyle(
        color: velvetAmethyst,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: const TextStyle(
        color: royalPlum,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: const TextStyle(
        color: textColor,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: royalPlum,
        foregroundColor: pearlWhite,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: champagneGold, width: 1.5),
        ),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color.fromARGB((0.1 * 255).toInt(), opulentLilac.r.toInt(),
          opulentLilac.g.toInt(), opulentLilac.b.toInt()),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: champagneGold),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: lavenderMist),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: champagneGold, width: 2),
      ),
      labelStyle: const TextStyle(color: velvetAmethyst),
      prefixIconColor: velvetAmethyst,
    ),
  );

  // static const BoxShadow luxuryShadow = BoxShadow(
  //   color: Color(0x33703D8A),
  //   blurRadius: 20,
  //   spreadRadius: 2,
  //   offset: Offset(0, 4),
  // );

  static const Color primaryColor = royalPlum;
  static const Gradient gradientPrimary = LinearGradient(
    colors: [royalPlum, velvetAmethyst],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const BoxShadow subtleShadow = BoxShadow(
    color: Color(0x33703D8A),
    blurRadius: 12,
    spreadRadius: 1,
    offset: Offset(0, 3),
  );

  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x554B0C66),
    blurRadius: 8,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );

  static const TextStyle inputLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: velvetAmethyst,
    letterSpacing: 0.3,
  );
}
