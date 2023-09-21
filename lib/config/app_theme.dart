

// import 'package:nb_utils/nb_utils.dart';

import '../manager/font_manager.dart';
import '../manager/styles_manager.dart';
import '../manager/values_manager.dart';
import 'app_colors.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation.

  // Define the light theme for the app.
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.appLayoutBackground,
    primaryColor: AppColors.appColorPrimary,
    primaryColorDark: AppColors.appColorPrimaryDark,
    useMaterial3: true,
    hoverColor: Colors.white54,
    splashColor:AppColors.appColorPrimary,
    dividerColor: AppColors.bodyWhite.withOpacity(0.4),
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,

        // app bar theme
    appBarTheme:  AppBarTheme(
       centerTitle: true,
        // color: AppColors.appColorPrimary,
        elevation: AppSize.s4,
        shadowColor: AppColors.appColorPrimaryDark,
        titleTextStyle:
            getRegularStyle(fontSize: FontSize.s16, color: AppColors.white),
      surfaceTintColor: AppColors.appLayoutBackground,
      color: AppColors.appLayoutBackground,
      // iconTheme: const IconThemeData(color: textPrimaryColor),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    ),

        // tab bar theme
    tabBarTheme: const TabBarTheme(
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Color(0xFFB6D5EF), width: 3))),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),

    //card theme
    cardTheme: const CardTheme(color: Colors.white),
    cardColor: AppColors.appSectionBackground,
    // iconTheme: const IconThemeData(color: textPrimaryColor),
    bottomSheetTheme:  BottomSheetThemeData(backgroundColor: AppColors.white),

    // button theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: AppColors.grey1,
        buttonColor: AppColors.appColorPrimary,
        splashColor: AppColors.appColorPrimaryDark),

        //radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(AppColors.appColorPrimary),
    ),// elevated button them
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: getRegularStyle(
                color: AppColors.white, fontSize: FontSize.s17), backgroundColor: AppColors.appColorPrimary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12)))),


    // text theme
    textTheme: TextTheme(
        displayLarge: getSemiBoldStyle(
            color: AppColors.bodyDark, fontSize: FontSize.s16),
        headlineLarge: getBoldStyle(
            color: AppColors.blackHeadline, fontSize: FontSize.s26),
        headlineMedium: getSemiBoldStyle(
            color: AppColors.blackHeadline, fontSize: FontSize.s24),
        titleMedium:
            getMediumStyle(color: AppColors.appColorPrimary, fontSize: FontSize.s16),
        labelSmall:
            getRegularStyle(color: AppColors.textgray, fontSize: FontSize.s12),
        labelMedium:
            getRegularStyle(color: AppColors.appColorPrimary, fontSize: FontSize.s14),
        bodyLarge: getRegularStyle(color: AppColors.grey1),
        bodySmall: getRegularStyle(color: AppColors.grey),
        bodyMedium: getRegularStyle(color: AppColors.darkGrey, fontSize: FontSize.s14),
        titleSmall:
            getBoldStyle(color: AppColors.appColorPrimary, fontSize: FontSize.s12),),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
        // content padding
        contentPadding: const EdgeInsets.all(AppPadding.p8),
        // hint style
        hintStyle:
            getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
        labelStyle:
            getMediumStyle(color: AppColors.grey, fontSize: FontSize.s14),
        errorStyle: getRegularStyle(color: AppColors.error),

        // enabled border style
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.grey, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),

        // focused border style
        focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.appColorPrimary, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

        // error border style
        errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),
        // focused border style
        focusedErrorBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.appColorPrimary, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)))),
    colorScheme: const ColorScheme.light(primary: AppColors.appColorPrimary)
        .copyWith(error: Colors.red),
  ).copyWith(
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.appColorPrimary),
  );

  // Define the dark theme for the app.
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.appBackgroundColorDark,
    useMaterial3: true,
    highlightColor: AppColors.appBackgroundColorDark,
    appBarTheme:  AppBarTheme(
      surfaceTintColor: AppColors.appBackgroundColorDark,
      color: AppColors.appBackgroundColorDark,
      iconTheme: IconThemeData(color: AppColors.white),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: AppColors.appColorPrimary,
    dividerColor: AppColors.bodyDark.withOpacity(0.4),
    primaryColorDark: AppColors.appColorPrimary,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
    hoverColor: Colors.black12,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.appBackgroundColorDark),
    // primaryTextTheme: TextTheme(
    //     titleLarge: primaryTextStyle(color: Colors.white),
    //     labelSmall: primaryTextStyle(color: Colors.white)),
    cardTheme: const CardTheme(color: AppColors.cardBackgroundBlackDark),
    cardColor: AppColors.cardBackgroundBlackDark,
    iconTheme:  IconThemeData(color: AppColors.white),
     //text theme
     textTheme: TextTheme(
        displayLarge: getSemiBoldStyle(
            color: AppColors.white, fontSize: FontSize.s16),
        headlineLarge: getSemiBoldStyle(
            color: AppColors.darkGrey, fontSize: FontSize.s16),
        headlineMedium: getRegularStyle(
            color: AppColors.darkGrey, fontSize: FontSize.s14),
        titleMedium:
            getMediumStyle(color: AppColors.appColorPrimary, fontSize: FontSize.s16),
        titleSmall:
            getRegularStyle(color: AppColors.white, fontSize: FontSize.s16),
        bodyLarge: getRegularStyle(color: AppColors.bodyWhite),
        bodySmall: getRegularStyle(color: AppColors.grey),
        bodyMedium: getRegularStyle(color: AppColors.grey2, fontSize: FontSize.s12),
        labelSmall:
            getBoldStyle(color: AppColors.appColorPrimary, fontSize: FontSize.s12)),

    tabBarTheme: const TabBarTheme(
        indicator:
            UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white))),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(AppColors.appColorPrimary),
    ),
    colorScheme: const ColorScheme.dark(
            primary: AppColors.appBackgroundColorDark,
            onPrimary: AppColors.cardBackgroundBlackDark)
        .copyWith(secondary: AppColors.white)
        .copyWith(error: const Color(0xFFCF6676)),
  ).copyWith(
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.appColorPrimary),
  );
}

