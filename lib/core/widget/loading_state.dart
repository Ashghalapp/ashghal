import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../localization/localization_strings.dart';

// class LoadingWidget extends StatelessWidget {
//   const LoadingWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       child: Center(
//         child: SizedBox(
//           height: 30,
//           width: 30,
//           child: EasyLoading.show(),
//         ),
//       ),
//     );
//   }
// }

LoadingWidget(){
  return EasyLoading.show(status: LocalizationString.loading);
}