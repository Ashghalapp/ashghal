import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key? key,
    required this.hintText,
    this.iconName,
    required this.label,
    required this.obscureText,
    required this.controller,
    this.validator,
    this.sufficxIconDataName,
    this.onPressed,
    this.prefixtext,
    this.inputformater,
    this.textInputtype,
    this.textDirection,
  }) : super(key: key);
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputformater;
  final TextInputType? textInputtype;
  final String label;
  final String? prefixtext;
  final String hintText;
  final String? iconName;
  final String? sufficxIconDataName;
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
      // style: Theme.of(context).inputDecorationTheme.labelStyle,
        style: const TextStyle(
      decoration: TextDecoration.none,
      decorationThickness: 0,
    ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            // borderSide: BorderSide.none
            ),
        hintText: label,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        prefixIcon: IconButton(
          onPressed: null,
          icon:iconName!=null? SvgPicture.asset(
            fit: BoxFit.contain,
            iconName!,
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
            // You can adjust the size as needed
            // width: 14,
            // height: 14,
          ):const SizedBox()
        ),
        suffixIcon: sufficxIconDataName != null
            ? IconButton(
                onPressed: onPressed,
                icon: SvgPicture.asset(
                  fit: BoxFit.contain,
                  sufficxIconDataName!,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                  // You can adjust the size as needed
                  // width: 14,
                  // height: 14,
                ),
                // Icon(sufficxIconDataName),
                color: Theme.of(context).iconTheme.color,
                iconSize: 22)
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
