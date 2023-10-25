// Here is the string to turn Hello red:

// \x1B[31mHello\x1B[0m
// And here it is again with spaces added for clarity between the parts:

// \x1B  [31m  Hello  \x1B  [0m
// Meaning:

// \x1B: ANSI escape sequence starting marker
// [31m: Escape sequence for red
// [0m: Escape sequence for reset (stop making the text red)
// Here are the other colors:

// Black:   \x1B[30m
// Red:     \x1B[31m
// Green:   \x1B[32m
// Yellow:  \x1B[33m
// Blue:    \x1B[34m
// Magenta: \x1B[35m
// Cyan:    \x1B[36m
// White:   \x1B[37m
// Reset:   \x1B[0m

class AppPrint {
  static void _printRed(String text) {
    print('\x1B[31m$text\x1B[0m');
  }

  static void _printGreen(String text) {
    print('\x1B[32m$text\x1B[0m');
  }

  static void _printYellow(String text) {
    print('\x1B[33m$text\x1B[0m');
  }

  static void _printWhite(String text) {
    print('\x1B[37m$text\x1B[0m');
  }

  static void printWarning(String text) {
    _printYellow(text);
  }

  static void printError(String text) {
    _printRed(text);
  }

  static void printInfo(String text) {
    _printGreen(text);
  }

  static void printSeperator(String text) {
    _printGreen(text);
  }

  static void printData(String text) {
    _printWhite(text);
  }
}
