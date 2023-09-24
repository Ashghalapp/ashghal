import 'package:equatable/equatable.dart';

class RemoteMultimedia extends Equatable {
  final int id;
  final String type;
  final String fileName;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RemoteMultimedia({
    required this.id,
    required this.type,
    required this.fileName,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        fileName,
        url,
        createdAt,
        updatedAt,
      ];
}
