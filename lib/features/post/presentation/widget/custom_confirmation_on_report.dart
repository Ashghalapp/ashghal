import 'package:flutter/material.dart';

// البوتوم شييت التي تظهر بعد عمل ابلاغ على بوست
class CustomConfirmationSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 64.0,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'ملاحظتك تهمنا لأنها تساعدنا في الحفاظ على مجتمع ASHGHAL APP',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
