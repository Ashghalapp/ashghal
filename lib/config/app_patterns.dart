class AppPatterns {
  static RegExp urlPattern = RegExp(
      r"http(s)?://[a-zA-Z0-9.-]+(\.[a-zA-Z]{2,4})+(?:[^\s]*)?",
      caseSensitive: false);
}
