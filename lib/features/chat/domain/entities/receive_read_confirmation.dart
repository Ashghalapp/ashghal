// These classes created to reprenets messages confirmation(Confirm Receive/Read Messages, Confirm you got Messages Receive/Read confirmation)
//Form1 (Confirm Receive/Read Messages) a response you get when you confirm that you recieved or read some messages sent to you
//   {
//     "success": [
//         {
//             "id": "5",
//             "at": "2023-08-03T19:40:33.723240Z"
//         },
//         {
//             "id": "6",
//             "at": "2023-08-03T19:40:33.730455Z"
//         },
//         {
//             "id": "8",
//             "at": "2023-08-03T19:40:33.738970Z"
//         }
//     ],
//     "failed": [
//         "1",
//         "2",
//         "3"
//     ]
// }
//Form1  (Confirm you got Messages Receive/Read confirmation) a response you got when confirm that you got a receive/read confirmation on some messges you got
//   {
//     "success": [
//         "15",
//         "7",
//         "9"
//     ],
//     "failed": [
//         "1",
//         "2",
//         "3"
//     ]
// }

import 'package:ashghal_app_frontend/features/chat/domain/entities/received_read_message.dart';
import 'package:equatable/equatable.dart';

class MainConfirmation extends Equatable {
  final List<int> failed;
  const MainConfirmation({
    required this.failed,
  });

  @override
  List<Object?> get props => [failed];
}

// This class represents the response of the chat messages' confirmation requests(Form1)
class RecieveReadConfirmation extends MainConfirmation {
  final List<ReceivedReadMessage> success;

  const RecieveReadConfirmation({
    required this.success,
    required List<int> failed,
  }) : super(failed: failed);

  @override
  List<Object?> get props => [failed, success];
}

// This class represents the response of the chat messages' confirmation requests(Form1)
class RecieveReadGotConfirmation extends MainConfirmation {
  final List<int> success;
  const RecieveReadGotConfirmation({
    required this.success,
    required List<int> failed,
  }) : super(failed: failed);

  @override
  List<Object?> get props => [failed, success];
}
