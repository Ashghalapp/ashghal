// import 'package:flutter/material.dart';

// class SendButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;

//   const SendButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ButtonStyle(
//         shape: MaterialStateProperty.all<OutlinedBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24),
//           ),
//         ),
//         backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//         elevation: MaterialStateProperty.all<double>(4),
//         overlayColor: MaterialStateProperty.all<Color>(Colors.red),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Text(
//           text,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
