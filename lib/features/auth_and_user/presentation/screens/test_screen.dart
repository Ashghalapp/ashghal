// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../../core/widget/app_buttons.dart';

// class TestScreen extends StatelessWidget {
//   const TestScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         surfaceTintColor: Colors.white,
//         toolbarHeight: 20,
//         backgroundColor: Colors.white,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           iconSize: 30,
//           items: [
//             BottomNavigationBarItem(
//                 icon: SvgPicture.asset(
//                   "assets/icons/icons/home.svg",
//                   colorFilter:
//                       const ColorFilter.mode(Colors.black, BlendMode.srcIn),
//                 ),
//                 label: ""),
//             BottomNavigationBarItem(
//                 icon: SvgPicture.asset(
//                   "assets/icons/icons/search.svg",
//                   colorFilter:
//                       ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn),
//                 ),
//                 label: ""),
//             BottomNavigationBarItem(
//                 icon: SvgPicture.asset(
//                   "assets/icons/icons/plus.svg",
//                   colorFilter:
//                       ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn),
//                 ),
//                 label: ""),
//             BottomNavigationBarItem(
//                 icon: SvgPicture.asset(
//                   "assets/icons/icons/like.svg",
//                   colorFilter:
//                       ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn),
//                 ),
//                 label: ""),
//             const BottomNavigationBarItem(
//                 icon: Icon(Icons.person_outline), label: ""),
//           ]),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 10,
//             ),
//             AppGesterDedector(onTap: () => (), text: 'Click')
//           ],
//         ),
//       ),
//     );
//   }
// }
