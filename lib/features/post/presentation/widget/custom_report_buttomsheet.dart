
import 'package:ashghal_app_frontend/features/post/presentation/getx/report_controller.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/custom_confirmation_on_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// البوتوم شييت التي تظهر اثناء عمل ابلاغ على بوست
// وتظهر في مجموعه من الخيارات
class CustomBottomSheet extends StatelessWidget {
  final ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "  لماذا تريد الإبلاغ عن هذا المنشور؟",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Obx(
            () => Column(
              children: reportController.reportOptions.map((option) {
                return RadioListTile<String>(
                  title: Text(
                    option.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: option.title,
                  groupValue: reportController.selectedOption.value,
                  onChanged: (value) {
                    reportController.selectedOption.value = value!;
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: reportController.customTextEditing,
              decoration: const InputDecoration(
                labelText: 'أضف سبب اخر',
                hintText: 'Enter your custom option',
              ),
              maxLines: null,
            ),
          ),
          Container(
            width: 300,
            alignment: Alignment.center,
            child: MaterialButton(
              onPressed: () {
                final selected = reportController.selectedOption.value;
                final custom = reportController.customTextEditing.text;
                reportController.customTextEditing.clear();
                final committedOption = custom.isNotEmpty ? custom : selected;
                print('Committed Option: $committedOption');
                // الدالة الخاصة بعمل الابلاغ بعد التاكيد
                reportController.commitReport(committedOption);
                Get.back();

                Get.bottomSheet(CustomConfirmationSheet());
                Future.delayed(const Duration(seconds: 3), () {
                  Get.back();
                });
              },
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text("تأكيــد"),
            ),
          ),
        ],
      ),
    );
  }
}
