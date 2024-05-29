//  Colores para usarlos en las vistas de la app
import 'package:flutter/material.dart';

class Colores {
  static const MaterialColor azul = MaterialColor(
    _azulPrimaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(_azulPrimaryValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  static const int _azulPrimaryValue = 0xFF1565C0;

  static const MaterialColor azulClaro = MaterialColor(
    _azulClaroPrimaryValue,
    <int, Color>{
      50: Color(0xFFE1F5FE),
      100: Color(0xFFB3E5FC),
      200: Color(0xFF81D4FA),
      300: Color(0xFF4FC3F7),
      400: Color(0xFF29B6F6),
      500: Color(_azulClaroPrimaryValue),
      600: Color(0xFF039BE5),
      700: Color(0xFF0288D1),
      800: Color(0xFF0277BD),
      900: Color(0xFF01579B),
    },
  );
  static const int _azulClaroPrimaryValue = 0xFF03A9F4;

  static const MaterialColor azulOscuro = MaterialColor(
    _azulOscuroPrimaryValue,
    <int, Color>{
      50: Color(0xFF000031),
      100: Color(0xFF00005C),
      200: Color(0xFF00008B),
      300: Color(0xFF0000BA),
      400: Color(0xFF0000E1),
      500: Color(_azulOscuroPrimaryValue),
      600: Color(0xFF0000FF),
      700: Color(0xFF3F51B5),
      800: Color(0xFF303F9F),
      900: Color(0xFF1A237E),
    },
  );
  static const int _azulOscuroPrimaryValue = 0xFF00008B;

  static const MaterialColor celeste = MaterialColor(
    _celestePrimaryValue,
    <int, Color>{
      50: Color(0xFFE0F7FA),
      100: Color(0xFFB2EBF2),
      200: Color(0xFF80DEEA),
      300: Color(0xFF4DD0E1),
      400: Color(0xFF26C6DA),
      500: Color(_celestePrimaryValue),
      600: Color(0xFF00ACC1),
      700: Color(0xFF0097A7),
      800: Color(0xFF00838F),
      900: Color(0xFF006064),
    },
  );
  static const int _celestePrimaryValue = 0xFF00FFFF;

  static const MaterialColor verde = MaterialColor(
    _verdePrimaryValue,
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(_verdePrimaryValue),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );
  static const int _verdePrimaryValue = 0xFF4CAF50;

  static const MaterialColor verdeOscuro = MaterialColor(
    _verdeOscuroPrimaryValue,
    <int, Color>{
      50: Color(0xFF003300),
      100: Color(0xFF006600),
      200: Color(0xFF009900),
      300: Color(0xFF00CC00),
      400: Color(0xFF00FF00),
      500: Color(_verdeOscuroPrimaryValue),
      600: Color(0xFF00FF00),
      700: Color(0xFF339933),
      800: Color(0xFF006600),
      900: Color(0xFF003300),
    },
  );
  static const int _verdeOscuroPrimaryValue = 0xFF006400;

  static const MaterialColor marron = MaterialColor(
    _marronPrimaryValue,
    <int, Color>{
      50: Color(0xFFC2A276),
      100: Color(0xFF98734B),
      200: Color(0xFF7C5C3A),
      300: Color(0xFF613E28),
      400: Color(0xFF4F2E1D),
      500: Color(_marronPrimaryValue),
      600: Color(0xFF3A1B0F),
      700: Color(0xFF2F160B),
      800: Color(0xFF240F07),
      900: Color(0xFF120803),
    },
  );
  static const int _marronPrimaryValue = 0xFF8B4513;

  static const MaterialColor rojo = MaterialColor(
    _rojoPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(_rojoPrimaryValue),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );
  static const int _rojoPrimaryValue = 0xFFFF0000;

  static const MaterialColor rojoOscuro = MaterialColor(
    _rojoOscuroPrimaryValue,
    <int, Color>{
      50: Color(0xFF330000),
      100: Color(0xFF660000),
      200: Color(0xFF990000),
      300: Color(0xFFCC0000),
      400: Color(0xFFFF0000),
      500: Color(_rojoOscuroPrimaryValue),
      600: Color(0xFFFF0000),
      700: Color(0xFF990000),
      800: Color(0xFF660000),
      900: Color(0xFF330000),
    },
  );
  static const int _rojoOscuroPrimaryValue = 0xFF8B0000;

  static const MaterialColor naranja = MaterialColor(
    _naranjaPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(_naranjaPrimaryValue),
      600: Color(0xFFFB8C00),
      700: Color(0xFFF57C00),
      800: Color(0xFFEF6C00),
      900: Color(0xFFE65100),
    },
  );
  static const int _naranjaPrimaryValue = 0xFFFF8C00;

  static const MaterialColor amarillo = MaterialColor(
    _amarilloPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFE0),
      100: Color(0xFFFFFFB2),
      200: Color(0xFFFFFF80),
      300: Color(0xFFFFFF4D),
      400: Color(0xFFFFFF26),
      500: Color(_amarilloPrimaryValue),
      600: Color(0xFFFFFF00),
      700: Color(0xFFFFFF00),
      800: Color(0xFFFFFF00),
      900: Color(0xFFFFFF00),
    },
  );
  static const int _amarilloPrimaryValue = 0xFFFFEB3B;

  static const MaterialColor amarilloClaro = MaterialColor(
    _amarilloClaroPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFCB4),
      100: Color(0xFFFFF8B2),
      200: Color(0xFFFFF4B1),
      300: Color(0xFFFFF0AF),
      400: Color(0xFFFFECAD),
      500: Color(_amarilloClaroPrimaryValue),
      600: Color(0xFFFFDAAA),
      700: Color(0xFFFFD6A9),
      800: Color(0xFFFFD2A7),
      900: Color(0xFFFFCEA6),
    },
  );
  static const int _amarilloClaroPrimaryValue = 0xFFFFF3B4;

  static const MaterialColor blanco = MaterialColor(
    _blancoPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(_blancoPrimaryValue),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static const int _blancoPrimaryValue = 0xFFFFFFFF;

  static const MaterialColor gris = MaterialColor(
    _grisPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      400: Color(0xFFBDBDBD),
      500: Color(_grisPrimaryValue),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      900: Color(0xFF212121),
    },
  );
  static const int _grisPrimaryValue = 0xFF808080;

  static const MaterialColor grisClaro = MaterialColor(
    _grisClaroPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA), // Mantén el tono original
      100: Color(0xFFF5F5F5), // Mantén el tono original
      200: Color(0xFFEEEEEE), // Mantén el tono original
      300: Color(0xFFE0E0E0), // Mantén el tono original
      400: Color(0xFFBDBDBD), // Mantén el tono original
      500: Color(_grisClaroPrimaryValue), // Nuevo tono más claro
      600: Color(0xFF757575), // Mantén el tono original
      700: Color(0xFF616161), // Mantén el tono original
      800: Color(0xFF424242), // Mantén el tono original
      900: Color(0xFF212121), // Mantén el tono original
    },
  );
  static const int _grisClaroPrimaryValue =
      0xFFCCCCCC; // Este valor es un gris más claro

  static const MaterialColor grisOscuro = MaterialColor(
    _grisOscuroPrimaryValue,
    <int, Color>{
      50: Color(0xFF3C3C3C), // Un poco más claro
      100: Color(0xFF3F3F3F), // Un poco más claro
      200: Color(0xFF424242), // Un poco más claro
      300: Color(0xFF454545), // Un poco más claro
      400: Color(0xFF484848), // Un poco más claro
      500: Color(_grisOscuroPrimaryValue),
      600: Color(0xFF4B4B4B), // Un poco más claro
      700: Color(0xFF4E4E4E), // Un poco más claro
      800: Color(0xFF515151), // Un poco más claro
      900: Color(0xFF545454), // Un poco más claro
    },
  );
  static const int _grisOscuroPrimaryValue =
      0xFF494949; // Ajusta el valor de color principal

  static const MaterialColor negro = MaterialColor(
    _negroPrimaryValue,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(_negroPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
  static const int _negroPrimaryValue = 0xFF000000;
}
