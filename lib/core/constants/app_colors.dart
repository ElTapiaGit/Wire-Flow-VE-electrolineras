import 'package:flutter/material.dart';

class AppTheme {
  // tema claro
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: const Color(0xFFE3E4E6),
    colorScheme: const ColorScheme.light(
      surface: Color(0xFFE3E4E6),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF4F6F8),
      surfaceContainer: Color(0xFFEBEFF1),
      
      onSurface: Color(0xFF1A1C1E),
      onSurfaceVariant: Color(0xFF505457),
      outline: Color(0xFF73777A),
      outlineVariant: Color(0xFFD1D5DB),

      // Acentos mas oscuros para que se lean sobre fondo blanco
      primary: Color(0xFF00657A), 
      primaryContainer: Color(0xFF008CC9),
      onPrimaryContainer: Color(0xFFFFFFFF),
      
      secondary: Color(0xFF006D36), 
      secondaryContainer: Color(0xFF10B981),
      onSecondaryContainer: Color(0xFFFFFFFF),
      
      tertiary: Color(0xFF8A5100),
      tertiaryContainer: Color(0xFFF59E0B),
      onTertiaryContainer: Color(0xFFFFFFFF),

      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFE53E3E),
      onErrorContainer: Color(0xFFFFFFFF),
    ),
  );

  // Tema oscuro
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    // Fondos y Superficies
    scaffoldBackgroundColor: const Color(0xFF131313),
    colorScheme: const ColorScheme.dark(
      surface : Color(0xFF131313),
      surfaceContainerLowest: Color(0xFF0e0e0e),
      surfaceContainerLow: Color(0xFF1c1b1b),
      surfaceContainer: Color(0xFF201f1f),

      surfaceContainerHigh: Color(0xFF2a2a2a),
      surfaceContainerHighest: Color(0xFF353534),
      
      // Textos e Iconos sobre superficies
      onSurface: Color(0xFFe5e2e1),
      onSurfaceVariant: Color(0xFFbbc9cf),
      outline: Color(0xFF859399),
      outlineVariant: Color(0xFF3c494e),

      // Acentos - Cian (Calculadora / Primario)
      primary: Color(0xFFa5e7ff),
      primaryContainer: Color(0xFF00d2ff),
      onPrimaryContainer: Color(0xFF00566a),
      onPrimary: Color(0xFF003543),

      // Acentos - Verde Eco (Comercial / Secundario)
      secondary: Color(0xFF7dffa2),
      secondaryContainer: Color(0xFF05e777),
      onSecondaryContainer: Color(0xFF00622e),

      // Acentos - Naranja/Ambar (Checklist / Terciario)
      tertiary: Color(0xFFffd5b4),
      tertiaryContainer: Color(0xFFffb068),
      onTertiaryContainer: Color(0xFF784100),

      // Alertas / Errores
      error: Color(0xFFffb4ab),
      errorContainer: Color(0xFF93000a),
      onErrorContainer: Color(0xFFffdad6),
    ),
  );
}