import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  late GlobalKey<FormState> addressFormKey;
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController descController;

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
