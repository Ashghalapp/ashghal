import 'package:ashghal_app_frontend/features/post/domain/entities/report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ReportController extends GetxController {
  //خيارات الابلاغ عن البوست
  final List<Report> reportOptions = [
    Report('التحريض على العنف'),
    Report('الكراهية والتمييز'),
    Report('انتحال اواحتيال شخصي'),
    Report('منشور غير مناسب أو صورة غير لائقة'),
  ];
  TextEditingController customTextEditing = TextEditingController();
  RxString selectedOption = "التحريض على العنف".obs;
// الدالة التي يتم استدعائها بعد التاكيد على عمل ابلاغ على بوست
// من الضروري اخذ البيانات التي تلز
  Future<void> commitReport(String reportCauses) async {}
}
