import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales basados en la imagen
  static const Color primaryBlue = Color(0xFF054A91);
  static const Color secondaryBlue = Color(0xFF3E7CB1); 
  static const Color lightBlue = Color(0xFF81A4CD); 
  static const Color backgroundLight = Color(0xFFDBE4EE); 
  static const Color accentOrange = Color(0xFFF17300); 

  // Colores de texto específicos
  static const Color textOnPrimaryBlue = Color(0xFFFFFFFF); 
  static const Color textOnSecondaryBlue = Color.fromARGB(255, 0, 0, 0); 
  static const Color textOnLightBlue = Color(0xFF054A91); 
  static const Color textOnBackgroundLight = Color(0xFF054A91); 
  static const Color textOnAccentOrange = Color(0xFFFFFFFF); 

// Colores adaptados para tema oscuro
  static const Color backgroundDark = Color(0xFF012A4A); 
  static const Color surfaceDark = Color(0xFF3E7CB1); 
  static const Color textOnDark = Color(0xFF81A4CD); 

  static const Color cardExpiredLight = Color.fromARGB(255, 253, 238, 237); 
  static const Color cardActiveLight = Color.fromARGB(255, 242, 255, 242); 
  static const Color cardExpiredDark = Color(0xFF4A1E1E); 
  static const Color cardActiveDark = Color(0xFF1E4A1E); 
  
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundDark,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      iconTheme: const IconThemeData(color: textOnPrimaryBlue),
      actionsIconTheme: const IconThemeData(color: textOnPrimaryBlue),
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: textOnPrimaryBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryBlue,
      secondary: secondaryBlue,
      surface: surfaceDark,
      error: accentOrange,
      onPrimary: textOnPrimaryBlue,
      onSecondary: textOnSecondaryBlue,
      onSurface: textOnDark,
      onError: textOnAccentOrange,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textOnPrimaryBlue, 
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: textOnPrimaryBlue, 
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: textOnPrimaryBlue, 
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: textOnDark, 
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: lightBlue, 
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: textOnDark,
        fontSize: 12,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundDark,
      selectedItemColor: primaryBlue,
      unselectedItemColor: lightBlue,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: accentOrange,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentOrange,
        foregroundColor: textOnAccentOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryBlue),
      ),
      labelStyle: const TextStyle(color: lightBlue),
      hintStyle: const TextStyle(color: secondaryBlue),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: accentOrange,
      contentTextStyle: const TextStyle(
        color: textOnAccentOrange,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );
 
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      iconTheme: const IconThemeData(color: textOnPrimaryBlue),
      actionsIconTheme: const IconThemeData(color: textOnPrimaryBlue),
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: textOnPrimaryBlue,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: primaryBlue,
      secondary: secondaryBlue,
      surface: Colors.white,
      error: accentOrange,
      onPrimary: textOnPrimaryBlue,
      onSecondary: textOnSecondaryBlue,
      onSurface: textOnSecondaryBlue,
      onError: textOnAccentOrange,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textOnSecondaryBlue,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: textOnSecondaryBlue,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
       headlineSmall: TextStyle(
        color: textOnSecondaryBlue, 
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: textOnSecondaryBlue, 
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textOnSecondaryBlue, 
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: textOnSecondaryBlue,
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        color: textOnSecondaryBlue,
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        color: textOnSecondaryBlue,
        fontSize: 14,
      ), 
      labelSmall: TextStyle(
        color: textOnSecondaryBlue,
        fontSize: 12,
      ), 
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryBlue,
      unselectedItemColor: lightBlue,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: accentOrange,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: textOnAccentOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundLight,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: textOnSecondaryBlue),
      ),
      labelStyle: const TextStyle(color: textOnSecondaryBlue),
      hintStyle: const TextStyle(color: secondaryBlue),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: accentOrange,
      contentTextStyle: const TextStyle(
        color: textOnAccentOrange,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );
}
