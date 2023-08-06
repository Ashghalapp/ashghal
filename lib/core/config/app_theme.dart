import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

ThemeData arTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  useMaterial3: true,
  primaryColor: AppColors.primaryColor,
  // fontFamily: 'Cairo',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: AppColors.primaryColor,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 26,
      color: AppColors.primaryColor,
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      height: 2,
      color: AppColors.secondaryText,
    ),
  ),
);

ThemeData enTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  primaryColor: const Color.fromRGBO(34, 34, 34, 1),
  primaryColorLight: Colors.grey.shade200,
  scaffoldBackgroundColor: AppColors.whiteColor,
 textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: AppColors.primaryColor,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 26,
      color: AppColors.primaryColor,
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      height: 2,
      color: AppColors.secondaryText,
    ),
    labelSmall: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: AppColors.LIGHT_PRIMARY_COLOR)
  ),
  // colorScheme: ColorScheme(
  //   brightness:
  //       Brightness.light, // Boilerplate code needed for colorScheme
  //   primary: Colors.white, // Boilerplate code needed for colorScheme
  //   onPrimary: Colors.white, // Boilerplate code needed for colorScheme
  //   secondary: Colors.white12, // Boilerplate code needed for colorScheme
  //   onSecondary:
  //       Colors.white12, // Boilerplate code needed for colorScheme
  //   error: Colors.red, // Boilerplate code needed for colorScheme
  //   onError: Colors.red[400]!, // Boilerplate code needed for colorScheme
  //   background: Colors.white,
  //   onBackground: Colors.white, // Boilerplate code needed for colorScheme
  //   surface: Colors.blueGrey, // Boilerplate code needed for colorScheme
  //   onSurface: Colors.blueGrey,

  //    // Boilerplate code needed for colorScheme
  // ),
);
// ThemeData darkTheme = ThemeData(
//     scaffoldBackgroundColor: const Color(0xff101010),
//     primaryColor: Colors.white,
//     primaryColorLight: Colors.grey.shade800);

  ThemeData    darkTheme= ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        primaryColor: const Color.fromRGBO(242, 242, 245, 1),
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color.fromRGBO(242, 242, 245, 1),
          onPrimary: Colors.white, // Boilerplate code needed for colorScheme
          secondary: Colors.white12, // Boilerplate code needed for colorScheme
          onSecondary:
              Colors.white12, // Boilerplate code needed for colorScheme
          error: Colors.red, // Boilerplate code needed for colorScheme
          onError: Colors.red[400]!, // Boilerplate code needed for colorScheme
          background: const Color.fromRGBO(17, 17, 17, 1),
          onBackground: Colors.white, // Boilerplate code needed for colorScheme
          surface: Colors.blueGrey, // Boilerplate code needed for colorScheme
          onSurface: Colors.blueGrey, // Boilerplate code needed for colorScheme
        ));
// ThemeData(
//   appBarTheme: const AppBarTheme(
//     systemOverlayStyle: SystemUiOverlayStyle.light,
//   ),
//   useMaterial3: true,
// primaryColor: AppColors.PRIMARY_COLOR,
//   primaryColorLight: AppColors.primaryColor,
//   fontFamily: 'PlayfairDisplay',
//   textTheme: const TextTheme(
//     displayLarge: TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 22,
//       color: AppColors.primaryColor,
//     ),
//     displayMedium: TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 26,
//       color: AppColors.primaryColor,
//     ),
//     bodyLarge: TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//       height: 2,
//       color: AppColors.secondaryText,
//     ),
//   ),
// );
