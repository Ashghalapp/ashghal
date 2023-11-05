class OnBoardingRequest {
  final String title;
  final String? subtitle;
  final int imagePath;

  OnBoardingRequest(
      {required this.title, required this.subtitle, required this.imagePath});

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'image_path': imagePath,
    };
  }
}
