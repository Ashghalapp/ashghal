import 'package:get/get.dart';

///دالة لفحص المدخلات
validInput(String? val, int? min, int? max, String? type,
    {String? confirmpassword}) {
  if (type == 'email' ||
      type == 'name' ||
      type == 'password' ||
      type == 'phonenumber' ||
      type == 'jobname' ||
      type == 'selectedCategory' ||
      type == 'username' ||
      type == 'confirmpassword') {
    if (GetUtils.isNullOrBlank(val)!) {
      return '44'.tr;
    }
  }
  if (type == 'email') {
    if (!GetUtils.isEmail(val!)) {
      return '45'.tr;
    }
  }
  if (type == 'phonenumber') {
    if (!GetUtils.isPhoneNumber(val!)) {
      return '45'.tr;
    }
  }
  if (type == 'username') {
    if (!GetUtils.isUsername(val!)) {
      return '46'.tr;
    }
    if (GetUtils.isLengthLessThan(val, min!)) {
      return '47'.tr;
    }
  }
  if (type == 'jobname') {
    // print("Job name///////////$val");
    if (val!.length > 100) {
      return "The job name must to be less 100 letters";
    }
  }
  if (type == 'password' || type == 'confirmpassword') {
    if (GetUtils.isLengthLessThan(val, min!)) {
      return '48'.tr;
    } else if (GetUtils.isLengthGreaterThan(val, max!)) {
      return '49'.tr;
    }
  }
  if (type == 'confirmpassword') {
    if (!GetUtils.isCaseInsensitiveContains(val!, confirmpassword!) &&
        val != confirmpassword) {
      return '50'.tr;
    }
  }
}
