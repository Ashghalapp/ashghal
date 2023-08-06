import 'package:equatable/equatable.dart';

abstract class Success extends Equatable{
  final String message;

  const Success(this.message);// = "There is something wrong. please try again...";
  // String get Messsge{
  //   return message;
  // }
}

class ServerSuccess extends Success{
  const ServerSuccess(super.message);

  @override
  List<Object?> get props => [];
}