import 'package:flutter/material.dart';

class MyGesterDedector extends StatelessWidget {
  const MyGesterDedector(
      {super.key, required this.onTap, required this.text, this.color});
  final void Function() onTap;
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    
      onTap: onTap,
      child: Container(
        height: 53,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                color: Colors.black12.withOpacity(.2),
                offset: const Offset(2, 2))
          ],
          borderRadius: BorderRadius.circular(10),
          // borderRadius: BorderRadius.circular(30).copyWith(
          //     topRight: Radius.circular(0), bottomLeft: Radius.circular(0)),
          // gradient: LinearGradient(colors: [
          //   Colors.purple.shade200,
          //   Colors.purple.shade900,
          // ],
          // ),
          color: color ?? Theme.of(context).primaryColor,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      // style: ElevatedButton.styleFrom(
      //   backgroundColor: Colors.deepPurple,
      //   shadowColor: Colors.deepPurple,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30),
      //   ),
      // ),
    );
  }
}

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton(
      {this.child,
      this.color,
      this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      Key? key})
      : super(key: key);
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // ThemeData currentTheme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor: color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed as void Function()?,
      child: child,
    );
  }
}

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton(
      {this.child,
      this.textColor,
      this.outlineColor,
      required this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      Key? key})
      : super(key: key);
  final Widget? child;
  final Function onPressed;
  final double borderRadius;
  final Color? outlineColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // ThemeData currentTheme = Theme.of(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor:
            textColor ?? outlineColor ?? Theme.of(context).primaryColor,
        padding: padding,
        textStyle: TextStyle(color: Theme.of(context).primaryColor),
        side: BorderSide(color: outlineColor ?? Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed as void Function()?,
      child: child!,
    );
  }
}

class MyElevatedButtonWithIcon extends StatelessWidget {
  const MyElevatedButtonWithIcon(
      {required this.label,
      this.color,
      this.iconData,
      this.iconColor,
      required this.onPressed,
      this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      Key? key})
      : super(key: key);
  final Color? iconColor;
  final Widget label;
  final Color? color;
  final IconData? iconData;
  final Function onPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed as void Function()?,
      icon: Icon(
        iconData,
        color: Colors.indigo,
      ),
      label: label,
      style: ElevatedButton.styleFrom(backgroundColor: color, padding: padding),
    );
  }
}

class MyCircularIconButton extends StatelessWidget {
  const MyCircularIconButton(
      {this.fillColor = Colors.transparent,
      required this.iconData,
      this.iconColor = Colors.blue,
      this.outlineColor = Colors.transparent,
      this.notificationFillColor = Colors.red,
      this.notificationCount,
      this.onPressed,
      this.radius = 48.0,
      Key? key})
      : super(key: key);

  final IconData iconData;
  final Color fillColor;
  final Color outlineColor;
  final Color iconColor;
  final Color notificationFillColor;
  final int? notificationCount;
  final Function? onPressed;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Ink(
          width: radius,
          height: radius,
          decoration: ShapeDecoration(
            color: fillColor,
            shape: CircleBorder(side: BorderSide(color: outlineColor)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: radius / 2,
            iconSize: radius / 2,
            icon: Icon(iconData, color: iconColor),
            splashColor: iconColor.withOpacity(.4),
            onPressed: onPressed as void Function()?,
          ),
        ),
        if (notificationCount != null) ...[
          Positioned(
            top: radius / -14,
            right: radius / -14,
            child: Container(
              width: radius / 2.2,
              height: radius / 2.2,
              decoration: ShapeDecoration(
                color: notificationFillColor,
                shape: const CircleBorder(),
              ),
              child: Center(
                child: Text(
                  notificationCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: radius / 4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
