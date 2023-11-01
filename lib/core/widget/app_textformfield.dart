import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class AppTextFormField extends StatelessWidget {
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputformater;
  final TextInputType? textInputtype;
  final String? hintText;
  final String? prefixtext;
  final String? labelText;
  final String? iconName;
  final String? sufficxIconDataName;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function()? onSuffixIconPressed;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool autoFocuse;
  final double radius;
  final int? minLines;
  final int? maxLines;
  final String? errorText;
  final bool readOnly;
  final void Function()? onTap;

  const AppTextFormField({
    Key? key,
    this.labelText,
    this.iconName,
    this.hintText,
    required this.obscureText,
    required this.controller,
    this.validator,
    this.sufficxIconDataName,
    this.onSuffixIconPressed,
    this.prefixtext,
    this.inputformater,
    this.textInputtype,
    this.textDirection,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    this.margin = const EdgeInsets.all(0),
    this.autoFocuse = false,
    this.radius = 12,
    this.minLines,
    this.maxLines,
    this.errorText,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        keyboardType: textInputtype,
        inputFormatters: inputformater,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        cursorColor: Theme.of(context).primaryColor,
        autofocus: autoFocuse,
        minLines: minLines,
        maxLines: obscureText ? 1 : maxLines,
        // style: Theme.of(context).inputDecorationTheme.labelStyle,
        style: const TextStyle(
          decoration: TextDecoration.none,
          decorationThickness: 0,
        ),
        decoration: InputDecoration(
          errorText: errorText,
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          prefixText: prefixtext,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
            // borderSide: BorderSide.none
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
            // borderSide: BorderSide.none
          ),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelSmall,
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
          alignLabelWithHint: false,

          prefixIcon: iconName != null
              ? IconButton(
                  onPressed: null,
                  icon: SvgPicture.asset(
                    fit: BoxFit.contain,
                    iconName!,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                    // You can adjust the size as needed
                    // width: 14,
                    // height: 14,
                  ),
                )
              : null,
          suffixIcon: sufficxIconDataName != null
              ? IconButton(
                  onPressed: onSuffixIconPressed,
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
          contentPadding: padding,
          // const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // label: Text(
          //   "",
          //   style: Theme.of(context).textTheme.labelSmall,
          // ),

          // borderSide: const BorderSide(color: AppColors.gray),
        ),
      ),
    );
  }
}
