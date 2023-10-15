import 'package:flutter/material.dart';

Color background = Color(0xfff3f2ee);
Color darkShadow = Color(0xffcfceca);
Color lightShadow = Color(0xffffffff);

Color textColor = Color(0xff001f3f);

Color onlineIndicator = Color(0xff0ee50a);

var softShadows = [
  BoxShadow(
      color: darkShadow,
      offset: const Offset(2.0, 2.0),
      blurRadius: 2.0,
      spreadRadius: 1.0),
  BoxShadow(
      color: lightShadow,
      offset: const Offset(-2.0, -2.0),
      blurRadius: 2.0,
      spreadRadius: 1.0),
];

var softShadowsInvert = [
  BoxShadow(
      color: lightShadow,
      offset: Offset(2.0, 2.0),
      blurRadius: 2.0,
      spreadRadius: 2.0),
  BoxShadow(
      color: darkShadow,
      offset: Offset(-2.0, -2.0),
      blurRadius: 2.0,
      spreadRadius: 2.0),
];

class ChatStyle {
  static const Color ownMessageColor = Colors.blueGrey;
  static const Color otherMessageColor = Color.fromARGB(255, 62, 92, 108);
  static const Color ownMessageTextColor = Colors.white;
  static const Color otherMessageTextColor = Colors.white;
  static const Color iconsBackColor = Colors.black38;

  // static const Color ownMessageColor = Colors.blueAccent;
  // static const Color otherMessageColor = Color.fromRGBO(130, 171, 238, 1);
  // static const Color ownMessageTextColor = Colors.white;
  // static const Color otherMessageTextColor = Colors.black;

  static const Color recievedMessages = Color.fromRGBO(60, 80, 100, 1);
  static const Color sentMessages = Color.fromRGBO(102, 102, 255, 1);
  static const Color messagesTime = Colors.lightBlue;
}

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

// This is our  main focus
// Let's apply light and dark theme on our app
// Now let's add dark theme on our app

// ThemeData lightThemeData(BuildContext context) {
//   return ThemeData.light().copyWith(
//     primaryColor: kPrimaryColor,
//     scaffoldBackgroundColor: Colors.white,
//     appBarTheme: appBarTheme,
//     iconTheme: const IconThemeData(color: kContentColorLightTheme),
//     textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
//         .apply(bodyColor: kContentColorLightTheme),
//     colorScheme: const ColorScheme.light(
//       primary: kPrimaryColor,
//       secondary: kSecondaryColor,
//       error: kErrorColor,
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: Colors.white,
//       selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
//       unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
//       selectedIconTheme: const IconThemeData(color: kPrimaryColor),
//       showUnselectedLabels: true,
//     ),
//   );
// }

// ThemeData darkThemeData(BuildContext context) {
//   // Bydefault flutter provie us light and dark theme
//   // we just modify it as our need
//   return ThemeData.dark().copyWith(
//     primaryColor: kPrimaryColor,
//     scaffoldBackgroundColor: kContentColorLightTheme,
//     appBarTheme: appBarTheme.copyWith(backgroundColor: kContentColorLightTheme),
//     iconTheme: const IconThemeData(color: kContentColorDarkTheme),
//     textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
//         .apply(bodyColor: kContentColorDarkTheme),
//     colorScheme: const ColorScheme.dark().copyWith(
//       primary: kPrimaryColor,
//       secondary: kSecondaryColor,
//       error: kErrorColor,
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: kContentColorLightTheme,
//       selectedItemColor: Colors.white70,
//       unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
//       selectedIconTheme: const IconThemeData(color: kPrimaryColor),
//       showUnselectedLabels: true,
//     ),
//   );
// }

// const appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
