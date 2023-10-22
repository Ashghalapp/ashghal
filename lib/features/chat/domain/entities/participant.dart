import 'package:equatable/equatable.dart';

class Participant extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? imageUrl;

  const Participant({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
      ];
}
