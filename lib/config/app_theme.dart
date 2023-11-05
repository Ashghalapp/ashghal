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
    unselectedWidgetColor: Colors.white,

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.appLayoutBackground,
      elevation: 5,
      foregroundColor: AppColors.appColorPrimary,
      shape: CircleBorder(),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(textStyle: TextTheme().bodyMedium),
    // brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.appLayoutBackground,
    primaryColor: AppColors.appColorPrimary,
    primaryColorDark: AppColors.appColorPrimaryDark,
    useMaterial3: true,
    hoverColor: Colors.grey[350],
    // splashColor:AppColors.appColorPrimary,
    // dividerColor: AppColors.dividerColorLight,
    dividerColor: AppColors.appDividerColorLight,
    // fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    fontFamily: GoogleFonts.urbanist().fontFamily,
    // app bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      // color: AppColors.appColorPrimary,
      // elevation: AppSize.s4,
      // shadowColor: AppColors.appColorPrimaryDark,
      titleTextStyle: getBoldStyle(
          fontSize: FontSize.s18, color: AppColors.appColorPrimary),
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
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.white),

    // button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: AppColors.grey1,
      buttonColor: AppColors.appColorPrimary,
      splashColor: AppColors.appColorPrimaryDark,
    ),

    //radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(AppColors.appColorPrimary),
    ), // elevated button them
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle:
              getRegularStyle(color: AppColors.white, fontSize: FontSize.s17),
          backgroundColor: AppColors.appColorPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12))),
    ),

    // text theme
    textTheme: TextTheme(
      displayLarge:
          getSemiBoldStyle(color: AppColors.bodyDark, fontSize: FontSize.s16),
      headlineLarge:
          getBoldStyle(color: AppColors.blackHeadline, fontSize: FontSize.s26),
      headlineMedium: getSemiBoldStyle(
          color: AppColors.blackHeadline, fontSize: FontSize.s24),
      titleMedium: getMediumStyle(
          color: AppColors.appColorPrimary, fontSize: FontSize.s20),
      titleLarge: getBoldStyle(
          color: AppColors.appColorPrimary, fontSize: FontSize.s28),
      labelSmall:
          getRegularStyle(color: AppColors.textgray, fontSize: FontSize.s12),
      labelMedium: getRegularStyle(
          color: AppColors.appColorPrimary, fontSize: FontSize.s14),
      bodyLarge:
          getRegularStyle(color: AppColors.grey1, fontSize: FontSize.s16),
      bodySmall: getRegularStyle(color: AppColors.bodyWhite),
      bodyMedium:
          getRegularStyle(color: AppColors.darkGrey, fontSize: FontSize.s14),
      titleSmall: getBoldStyle(
          color: AppColors.appColorPrimary, fontSize: FontSize.s12),
    ),

////////////// ICONS THEME /////////
    iconTheme: const IconThemeData(
      color: AppColors.iconColorPrimaryDark,
// size: 12
    ),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
        focusColor: AppColors.appColorPrimary,
        filled: true,
        fillColor: AppColors.appFillColorlight,

        // content padding
        contentPadding: const EdgeInsets.all(AppPadding.p8),
        // hint style
        hintStyle: getRegularStyle(
            color: AppColors.blackHeadline, fontSize: FontSize.s14),
        labelStyle:
            getMediumStyle(color: AppColors.bodyDark1, fontSize: FontSize.s14),
        errorStyle: getRegularStyle(color: AppColors.error),

        // enabled border style
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.appColorPrimary, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
        border: InputBorder.none,
        // focused border style
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.appColorPrimary, width: AppSize.s1_5),
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

        // error border style
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),
        // focused border style
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)))),
    colorScheme: const ColorScheme.light(primary: AppColors.appColorPrimary)
        .copyWith(error: Colors.red),
  ).copyWith(
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.appColorPrimary),
  );

  /////////// DARK THEME ////////////////
  static final ThemeData darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.grey,
      shape: CircleBorder(),
      elevation: 5,
    ),

//  brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.appBackgroundColorDark,
    primaryColor: AppColors.appColorPrimary,
    primaryColorDark: AppColors.appColorPrimaryDark,
    useMaterial3: true,
    hoverColor: Colors.black54,
    // splashColor: AppColors.appColorPrimary,
    // dividerColor: AppColors.appDividerColorDark,
    dividerColor: AppColors.appDividerColorDark,
    // fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    fontFamily: GoogleFonts.urbanist().fontFamily,
    // app bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      // elevation: AppSize.s4,
      // shadowColor: AppColors.appColorPrimaryDark,
      titleTextStyle:
          getRegularStyle(fontSize: FontSize.s16, color: AppColors.white),
      surfaceTintColor: AppColors.appBackgroundColorDark,
      color: AppColors.appBackgroundColorDark,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),

    // tab bar theme
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xFFB6D5EF), width: 3),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),

    // card theme
    cardTheme: const CardTheme(color: AppColors.cardBackgroundBlackDark),
    cardColor: AppColors.cardBackgroundBlackDark,

    // button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: AppColors.grey1,
      buttonColor: AppColors.appColorPrimary,
      splashColor: AppColors.appColorPrimaryDark,
    ),

    // radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(AppColors.appColorPrimary),
    ),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle:
            getRegularStyle(color: AppColors.white, fontSize: FontSize.s17),
        backgroundColor: AppColors.appColorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),

    // text theme
    textTheme: TextTheme(
      displayLarge:
          getSemiBoldStyle(color: AppColors.bodyDark, fontSize: FontSize.s16),
      headlineLarge:
          getBoldStyle(color: AppColors.bodyDark, fontSize: FontSize.s30),
      headlineMedium: getSemiBoldStyle(
          color: AppColors.blackHeadline, fontSize: FontSize.s24),
         titleLarge: getBoldStyle(
          color: AppColors.appColorPrimary, fontSize: FontSize.s28),
      titleMedium: getMediumStyle(
          color: AppColors.appColorPrimary, fontSize: FontSize.s20),
      labelSmall:
          getRegularStyle(color: AppColors.textgray, fontSize: FontSize.s12),
      labelMedium: getRegularStyle(
          color: AppColors.appColorPrimary, fontSize: FontSize.s14),
      bodyLarge: getRegularStyle(color: AppColors.grey1),
      bodySmall:
          getRegularStyle(color: AppColors.bodyDark1, fontSize: AppSize.s12),
      bodyMedium:
          getRegularStyle(color: AppColors.bodyDark, fontSize: FontSize.s14),
      titleSmall: getBoldStyle(
          color: AppColors.appColorPrimary, fontSize: FontSize.s12),
    ),

    /////// ICONS THEME ////////////////
    iconTheme: const IconThemeData(color: AppColors.iconColorPrimaryDark),

    ////////// input decoration theme (text form field)//////////////
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.appFillColorDark,
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      hintStyle:
          getRegularStyle(color: AppColors.bodyDark1, fontSize: FontSize.s14),
      labelStyle:
          getMediumStyle(color: AppColors.bodyDark1, fontSize: FontSize.s14),
      errorStyle: getRegularStyle(color: AppColors.error),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.bodyDark1, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.appColorPrimary, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.error, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: AppColors.appColorPrimary, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
    ),
    colorScheme: const ColorScheme.dark(primary: AppColors.appColorPrimary)
        .copyWith(error: Colors.red),
  ).copyWith(
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: AppColors.appColorPrimary),
  );
}
