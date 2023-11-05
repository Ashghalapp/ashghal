import 'package:ashghal_app_frontend/core/cities_and_districts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  late GlobalKey<FormState> addressFormKey;
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController descController;

  RxList<District> districts= <District>[].obs;

  Rx<int?> selectedCityId = Rx(null);
  Rx<int?> selectedDistrict = Rx(null);

  @override
  void onInit() {
    super.onInit();
    addressFormKey = GlobalKey();
    cityController = TextEditingController();
    streetController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void onClose() {
    cityController.dispose();
    streetController.dispose();
    descController.dispose();
    super.onClose();
  }
}
