import '../../domain/entities/multimedia.dart';

class MultimediaModel extends Multimedia {
  const MultimediaModel({
    required super.id,
    required super.type,
    required super.fileName,
    required super.url,
    required super.createdAt,
    required super.updatedAt,
  });

  // Function to convert a Map to a MultimediaModel instance
  factory MultimediaModel.fromJson(Map<String, dynamic> json) {
    return MultimediaModel(
      id: json['id'],
      type: json['type'],
      fileName: json['file_name'],
      url: json['file_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Function to convert a List of Maps to a List of MultimediaModel instances
  static List<MultimediaModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MultimediaModel.fromJson(json)).toList();
  }

  // Function to convert a MultimediaModel instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'file_name': fileName,
      'file_url': url,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }

  @override
  String toString() {
    return 'MultimediaModel(id: $id, type: $type, fileName: $fileName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Function to create a copy of the current instance with some updated fields
  MultimediaModel copyWith({
    int? id,
    String? type,
    String? path,
    String? url,
    String? fileName,
    bool? isMessage,
    int? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MultimediaModel(
      id: id ?? this.id,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
