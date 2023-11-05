import '../../domain/entities/onboarding.dart';

class OnBoardingModel extends OnBoarding {
  OnBoardingModel({
    required String title,
    required String subtitle,
    required String imagePath,
  }) : super(
          title: title,
          subtitle: subtitle,
          imagePath: imagePath,
        );

  factory OnBoardingModel.fromJson(Map<String, dynamic> json) {
    return OnBoardingModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
    };
  }
}
