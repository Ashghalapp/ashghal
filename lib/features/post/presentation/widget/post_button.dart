// import 'package:flutter/material.dart';

// class PostButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   Color? color = Colors.white;
//   Color? secondaryColor = Colors.red;
//   IconData? icon = Icons.camera_alt;
//   PostButton({
//     required this.text,
//     required this.onPressed,
//     this.secondaryColor,
//     this.color,
//     this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ButtonStyle(
//           foregroundColor: const MaterialStatePropertyAll(Colors.white),
//           shape: MaterialStateProperty.all<OutlinedBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(24),
//             ),
//           ),
//           backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//           elevation: MaterialStateProperty.all<double>(4),
//           overlayColor:
//               MaterialStateProperty.all<Color>(secondaryColor ?? Colors.red),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Adjust the spacing between the icon and text
//               Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Icon(
//                 icon, // Replace with your desired icon
//                 color: color, // Icon color
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
