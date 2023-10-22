//This class is used to represent a response you get when you confirm that you recieved or read
//some messages sent to you
import 'package:equatable/equatable.dart';

class ReceivedReadMessage extends Equatable {
  final int id;
  final DateTime at;

  const ReceivedReadMessage({
    required this.id,
    required this.at,
  });

  @override
  List<Object?> get props => [id, at];
}
