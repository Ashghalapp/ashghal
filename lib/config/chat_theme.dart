import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class ChatColors {
  static const primary = Colors.blue;
  static const secondary = Color(0xFF3B76F6);
  static const accent = Color(0xFFD6755B);
  static const textDark = Color(0xFF53585A);
  static const textLigth = Color(0xFFF5F5F5);
  static const textFaded = Color(0xFF9899A5);
  static const iconLight = Color(0xFFB1B4C0);
  static const iconDark = Color(0xFFB1B3C1);
  static const textHighlight = secondary;
  static const cardLight = Color(0xFFF9FAFE);
  static const cardDark = Color(0xFF303334);
  static const appBarLight = Colors.white70;
  static const appBarDark = Color(0xFF303334);
  static const scaffoldDarkBackground = Color(0xFF1B1E1F);
}

abstract class _LightColors {
  static const background = Colors.white;
  static const card = ChatColors.cardLight;
}

abstract class _DarkColors {
  static const background = Color(0xFF1B1E1F);
  static const card = ChatColors.cardDark;
}

/// Reference to the application theme.
class ChatTheme {
  static const accentColor = ChatColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  static final darkBase = ThemeData.dark();
  static final lightBase = ThemeData.light();

  /// Light theme and its settings.
  static ThemeData get light => ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.light,
        visualDensity: visualDensity,
        textTheme:
            GoogleFonts.mulishTextTheme().apply(bodyColor: ChatColors.textDark),
        appBarTheme: lightBase.appBarTheme.copyWith(
          iconTheme: lightBase.iconTheme,
          // backgroundColor: Colors.white60,
          backgroundColor: ChatColors.appBarLight,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: ChatColors.textDark,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        scaffoldBackgroundColor: _LightColors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(backgroundColor: ChatColors.secondary),
        ),
        cardColor: _LightColors.card,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: ChatColors.textDark),
        ),
        iconTheme: const IconThemeData(color: ChatColors.iconDark),
        colorScheme: lightBase.colorScheme
            .copyWith(secondary: accentColor)
            .copyWith(background: _LightColors.background),
      );

  /// Dark theme and its settings.
  static ThemeData get dark => ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: visualDensity,
        textTheme:
            GoogleFonts.interTextTheme().apply(bodyColor: ChatColors.textLigth),
        appBarTheme: darkBase.appBarTheme.copyWith(
          backgroundColor: ChatColors.appBarDark,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        scaffoldBackgroundColor: _DarkColors.background,
        // scaffoldBackgroundColor: const Color.fromRGBO(34, 48, 60, 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(backgroundColor: ChatColors.secondary),
        ),
        cardColor: _DarkColors.card,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: ChatColors.textLigth),
        ),
        iconTheme: const IconThemeData(color: ChatColors.iconLight),
        colorScheme: darkBase.colorScheme
            .copyWith(secondary: accentColor)
            .copyWith(background: _DarkColors.background),
      );
}
