import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String? code;
  final String message;
  final dynamic errors;

  const Failure({this.code, required this.message, this.errors});// = "There is something wrong. please try again...";
}

// لتمثيل الاخطاء القادمة من جهة المستخدم في حالة عدم الاتصال بالانترنت
class OfflineFailure extends Failure{
  const OfflineFailure({required super.message, super.errors});
  
  @override
  List<Object?> get props => [];
}

// لتمثيل الاخطاء القادة من جهة السرفر
class ServerFailure extends Failure{
  const ServerFailure({super.code, required super.message, super.errors});

  @override
  List<Object?> get props => [];
}

// لتمثيل الاخطاء القادمة من عملية سحب البيانات من التخزين المحلي
// مثلا اذا لم يتوفر انترنت سنقوم بسحب البيانات من التخزين المحلي ولكن 
// ربما لن يكون هناك بيانات في التخزين المحلي او المؤقت
class EmptyCacheFailure extends Failure{
  const EmptyCacheFailure({required super.message, super.errors});

  @override
  List<Object?> get props => [];
}

class NotSpecificFailure extends Failure{
  const NotSpecificFailure({required super.message, super.errors});

  @override
  List<Object?> get props => [];
}