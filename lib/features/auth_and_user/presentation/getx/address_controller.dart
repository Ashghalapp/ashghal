import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController{
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController descController;

  @override
  void onInit() {
    
    super.onInit();
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