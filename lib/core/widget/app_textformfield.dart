


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_colors.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key? key,
    required this.hintText,
    required this.iconData,
    required this.lable,
    required this.obscureText,
    required this.controller,
    this.validator,
    this.sufficxIconData,
    this.onPressed,
    this.prefixtext,  this.inputformater,  this.textInputtype, this.textDirection,
  }) : super(key: key);
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputformater;
  final TextInputType ?textInputtype;
  final String lable;
  final String? prefixtext;
  final String hintText;
  final IconData iconData;
  final IconData? sufficxIconData;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
    // textAlign:TextAlign.left,
    //   textDirection:TextDirection.rtl,
       keyboardType: textInputtype,
  inputFormatters: inputformater,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      cursorColor:Theme.of(context).primaryColor,
      style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          height: 2,
          color: Colors.grey),
      decoration: InputDecoration(prefixText:prefixtext,
        border: OutlineInputBorder(
          
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        hintText: lable,
        hintStyle: const TextStyle(color: AppColors.secondaryText),
        prefixIcon: Icon(
          iconData,
          color: Theme.of(context).primaryColor,
          size: 22,
        ),
        suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(sufficxIconData),
            color: AppColors.secondaryText,
            iconSize: 22),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: const Text(
          "",
          style: TextStyle(color: AppColors.ACCENT_COLOR, fontSize: 16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // borderRadius: BorderRadius.circular(30).copyWith(
          //   topRight: Radius.zero,
          //   bottomLeft: Radius.zero,
          //   // topLeft: Radius.circular(0),
          //   // bottomRight: Radius.circular(0),
          // ),
        ),
        // borderSide: const BorderSide(color: AppColors.gray),
      ),
    );
  }
}
