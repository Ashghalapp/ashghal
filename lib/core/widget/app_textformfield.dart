import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



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
    this.prefixtext,
    this.inputformater,
    this.textInputtype,
    this.textDirection,
  }) : super(key: key);
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputformater;
  final TextInputType? textInputtype;
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
      
      keyboardType: textInputtype,
      inputFormatters: inputformater,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      cursorColor: Theme.of(context).primaryColor,
      style: Theme.of(context).inputDecorationTheme.labelStyle,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixText: prefixtext,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            // borderSide: BorderSide.none
            ),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            
            borderSide: BorderSide.none),
        hintText: lable,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        prefixIcon: Icon(
          iconData,
          color: AppColors.grey,
          // size: 22,
        ),
        suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(sufficxIconData),
            color: Theme.of(context).iconTheme.color,
            iconSize: 22),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          "",
          style: Theme.of(context).textTheme.labelSmall,
        ),
       
        // borderSide: const BorderSide(color: AppColors.gray),
      ),
    );
  }
}
